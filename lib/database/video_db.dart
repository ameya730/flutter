import 'dart:io';
import 'package:get_storage/get_storage.dart';
import 'package:gshala/models/1.1_userprofiles_sqlite_model.dart';
import 'package:gshala/models/2.0_videodetails_sqflite_model.dart';
import 'package:gshala/models/2.1_videodownload_sqflite_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  static const String VIDEO_DOWNLOAD = "videoDownload";
  static const String VIDEO_DETAILS = "videoDetails";
  static const String COLUMN_ID = "id";
  static const String COLUMN_USER_ID = "UserId";
  static const String COLUMN_LESSONPLANID = "LessonPlanId"; //always set to 0
  static const String COLUMN_VIDEO_ID =
      "ResourceNodeId"; //Unique ID of the video
  static const String COLUMN_DOC_TYPE =
      "Type"; //Type of document. Set by default to video
  static const String COLUMN_VIDEO_INITIALIZE_DATE =
      "CreatedOn"; //When the video was initialized
  static const String COLUMN_VIDEO_VIEW_TIME = "TotalTime";
  static const String COLUMN_VIEW_START_TIME = "StartTime";
  static const String COLUMN_VIEW_END_TIME = "EndTime";
  static const String COLUMN_CURRENT_VIEW_DATE = "ModifiedOn";
  static const String COLUMN_VIEW_ISCOMPLETED = "IsCompleted";
  static const String COLUMN_VIEW_COMPLETED_DATE = "CompletedDate";
  static const String COLUMN_TOTAL_VIEW_DURATION = "TotalTimeSpent";
  static const String COLUMN_VIDEO_DATA_UPLOADED = "videoDataUpdated";
  static const String COLUMN_VIDEO_DELETED = "videoDeleted";
  static const String COLUMN_VIDEO_NAME = "videoName";
  static const String COLUMN_LAST_POSTION = "videoLastViewPosition";
  static const String COLUMN_VIDEO_ID_DOWNLOAD = "nodeid";
  static const String COLUMN_VID_URL = "vid_url";
  static const String COLUMN_NODE_NAME = "nodename";
  static const String COLUMN_TOPIC = "Topic";
  static const String COLUMN_CHAPTER = "chapter";
  static const String COLUMN_CLASS = "Class";
  static const String COLUMN_SUBJECT_NAME = "SubjectName";

  //Column names for user profiles database
  static const String USER_PROFILES = 'userProfiles';
  static const String USER_NAME = 'userName';
  static const String FIRST_NAME = 'firstName';
  static const String LAST_NAME = 'lastName';
  static const String USER_ID = 'userId';
  static const String PROFILE_PIC = 'profilePic';
  static const String MOBILE_NUMBER = 'mobileNumber';
  static const String GENDER = 'gender';
  static const String BATCH_NAME = 'batchName';

  static final DatabaseProvider db = DatabaseProvider._init();
  static Database? _database;
  DatabaseProvider._init();

  //Call Database
  Future<Database> get database async {
    print('database getter called');
    if (_database != null) {
      return _database!;
    }
    _database = await createDatabase();
    return _database!;
  }

  Future<Database> createDatabase() async {
    String dbPath = await getDatabasesPath();
    return await openDatabase(
      join(dbPath, 'videoDetails.db'),
      version: 1,
      onCreate: (Database database, int version) async {
        print('Creating new database for video details');

        //Create user profiles database
        await database.execute(
          "CREATE TABLE $USER_PROFILES ("
          "$COLUMN_ID INTEGER PRIMARY KEY AUTOINCREMENT,"
          "$USER_NAME TEXT NOT NULL,"
          "$FIRST_NAME TEXT NOT NULL,"
          "$LAST_NAME TEXT NOT NULL,"
          "$USER_ID INT NOT NULL,"
          "$PROFILE_PIC INT,"
          "$MOBILE_NUMBER INT NOT NULL,"
          "$GENDER TEXT NOT NULL,"
          "$BATCH_NAME TEXT NOT NULL"
          ")",
        );

        //Create video download database
        await database.execute(
          "CREATE TABLE $VIDEO_DOWNLOAD ("
          "$COLUMN_ID INTEGER PRIMARY KEY AUTOINCREMENT,"
          "$COLUMN_USER_ID INT NOT NULL,"
          "$COLUMN_VIDEO_ID INT NOT NULL,"
          "$COLUMN_LAST_POSTION INT NOT NULL,"
          "$COLUMN_VIDEO_NAME TEXT NOT NULL,"
          "$COLUMN_VIDEO_DELETED INT NOT NULL,"
          "$COLUMN_VIDEO_ID_DOWNLOAD INT NOT NULL,"
          "$COLUMN_VID_URL TEXT NOT NULL,"
          "$COLUMN_NODE_NAME TEXT NOT NULL,"
          "$COLUMN_TOPIC TEXT NOT NULL,"
          "$COLUMN_CHAPTER TEXT NOT NULL,"
          "$COLUMN_CLASS INT NOT NULL,"
          "$COLUMN_SUBJECT_NAME TEXT NOT NULL"
          ")",
        );

        //Create video statistics database
        await database.execute(
          "CREATE TABLE $VIDEO_DETAILS ("
          "$COLUMN_ID INTEGER PRIMARY KEY AUTOINCREMENT,"
          "$COLUMN_USER_ID INT NOT NULL,"
          "$COLUMN_LESSONPLANID INT NOT NULL,"
          "$COLUMN_VIDEO_ID INT NOT NULL,"
          "$COLUMN_DOC_TYPE TEXT NOT NULL,"
          "$COLUMN_VIDEO_INITIALIZE_DATE TEXT NOT NULL,"
          "$COLUMN_VIDEO_VIEW_TIME INT NOT NULL,"
          "$COLUMN_VIEW_START_TIME INT NOT NULL,"
          "$COLUMN_VIEW_END_TIME INT NOT NULL,"
          "$COLUMN_CURRENT_VIEW_DATE STRING NOT NULL,"
          "$COLUMN_VIEW_ISCOMPLETED INT,"
          "$COLUMN_VIEW_COMPLETED_DATE,"
          "$COLUMN_TOTAL_VIEW_DURATION INT NOT NULL,"
          "$COLUMN_VIDEO_DATA_UPLOADED INT,"
          "$COLUMN_VIDEO_DELETED INT,"
          "$COLUMN_VIDEO_NAME TEXT NOT NULL"
          ")",
        );
      },
    );
  }

  //Function for duplicate check while downloading a video. The same video can be downloaded if the user is different
  Future<int> profileDuplicateControl(int userId) async {
    final db = await database;
    var count = await db
        .query(USER_PROFILES, where: '$USER_ID = ?', whereArgs: [userId]);
    print('count is $count');
    return count.length;
  }

  //Insert user profiles in the user profiles table
  insertUserProfiles(UserProfiles userProfiles) async {
    print('testing');
    final db = await database;
    int count = await db.insert(USER_PROFILES, userProfiles.toJson());
    print('Inserted count is $count');
    return count;
  }

  //Get the list of all profiles for a user
  Future getAllProfiles() async {
    final db = await database;
    final box = new GetStorage();
    List<Map<String, dynamic>> profileList = await db.query(
      USER_PROFILES,
      // where: '$MOBILE_NUMBER = ?',
      // whereArgs: [int.parse(box.read('userName'))],
    );
    print('success');

    var profiles = profileList
        .map(
          (e) => UserProfiles(
            userName: e['userName'],
            firstName: e['firstName'],
            batchname: e['batchName'],
          ),
        )
        .toList();
    return profiles;
  }

  //Delete all profiles on sign-out
  Future<int> deleteProfiles() async {
    final db = await database;
    final box = new GetStorage();
    print(box.read('userName').toString());

    int counter = await db.delete(
      USER_PROFILES,
    );
    return counter;
  }

  //Insert new video in the video download table
  Future<VideoDownload> insertNewVideo(VideoDownload videoDownload) async {
    final db = await database;
    videoDownload.id = await db.insert(VIDEO_DOWNLOAD, videoDownload.toMap());
    return videoDownload;
  }

  //Insert current instance video view details
  Future updateVideoLastPosition(int lastPosition, String videoName) async {
    final db = await database;
    print('LastPositionIs $lastPosition');
    print('Video Name is $videoName');

    return db.rawUpdate(
      'UPDATE videoDownload SET videoLastViewPosition = ? WHERE videoName = ?',
      [lastPosition, videoName],
    );
  }

  //Insert current instance video view details
  Future<VideoDetails> insertVideoStatistics(VideoDetails videoDetails) async {
    final db = await database;
    videoDetails.id = await db.insert(VIDEO_DETAILS, videoDetails.toMap());
    return videoDetails;
  }

  //Get the list of all offline videos for a particular user
  Future getAllVideos() async {
    final db = await database;
    final box = new GetStorage();
    List<Map<String, dynamic>> vList = await db.query(
      VIDEO_DOWNLOAD,
      where: '$COLUMN_VIDEO_DELETED = ? and $COLUMN_USER_ID = ?',
      whereArgs: [0, int.parse(box.read('userId'))],
    );
    vList.forEach((element) {
      print('Element is $element');
    });
    return vList.map((e) => VideoDownload.fromMap(e)).toList();
  }

  //Function for duplicate check while downloading a video. The same video can be downloaded if the user is different
  Future<int> videoDownloadControl(int nodeId) async {
    final db = await database;
    final box = GetStorage();

    var count = await db.query(VIDEO_DOWNLOAD,
        where: '$COLUMN_VIDEO_ID_DOWNLOAD = ? and $COLUMN_USER_ID = ?',
        whereArgs: [nodeId, box.read('userId')]);
    return count.length;
  }

  //Get single video value
  Future<List<VideoDownload>> getSingleVideo(String vName) async {
    final db = await database;
    List<Map<String, dynamic>> lastPosition = await db.query(
      VIDEO_DOWNLOAD,
      where: '$COLUMN_VIDEO_NAME=?',
      whereArgs: [vName],
    );
    return lastPosition.map((e) => VideoDownload.fromMap(e)).toList();
  }

  getVideoStatistics() async {
    final db = await database;
    List<Map<String, dynamic>> videoJsonFile = await db.query(VIDEO_DETAILS,
        columns: [
          COLUMN_USER_ID,
          COLUMN_LESSONPLANID,
          COLUMN_VIDEO_ID,
          COLUMN_DOC_TYPE,
          COLUMN_VIDEO_INITIALIZE_DATE,
          COLUMN_VIDEO_VIEW_TIME,
          COLUMN_VIEW_START_TIME,
          COLUMN_VIEW_END_TIME,
          COLUMN_CURRENT_VIEW_DATE,
          COLUMN_VIEW_ISCOMPLETED,
          COLUMN_VIEW_COMPLETED_DATE,
          COLUMN_TOTAL_VIEW_DURATION
        ],
        where: '$COLUMN_VIDEO_DATA_UPLOADED=?',
        whereArgs: [0]);

    return videoJsonFile.toList();
  }

  updateVideoDetails() async {
    final db = await database;
    return await db.rawUpdate(
      'UPDATE videoDetails SET videoDataUpdated = ? WHERE videoDataUpdated = ?',
      [1, 0],
    );
  }

  //Delete the video from the VideoDownloaded Database
  Future<int> updateDeleteVideoFlat(String videoName) async {
    final db = await database;
    final box = new GetStorage();

    int count = await db.rawUpdate(
      'UPDATE $VIDEO_DOWNLOAD SET $COLUMN_VIDEO_DELETED = ? WHERE $COLUMN_VIDEO_NAME = ? and $COLUMN_USER_ID = ?',
      [
        1,
        videoName,
        box.read('userId'),
      ],
    );

    print(count);

    int counter = await db.delete(VIDEO_DOWNLOAD,
        where: '$COLUMN_VIDEO_NAME =? and $COLUMN_USER_ID = ?',
        whereArgs: [videoName, box.read('userId')]);

    return counter;
  }

  // If file has been deleted from the database and details of usage have been uploaded on server then the file can be deleted from local path
  Future delete(String videoName) async {
    final box = GetStorage();
    int userId = int.parse(
      box.read('userId'),
    );
    final db = await database;
    Directory appDir = await getApplicationDocumentsDirectory();
    File file = File(appDir.path + '/videos/$userId/' + videoName);
    file.exists().then((value) {
      file.delete();
    });
    return await db.delete(VIDEO_DOWNLOAD,
        where: "$COLUMN_VIDEO_DELETED = ? and $COLUMN_VIDEO_DATA_UPLOADED=?",
        whereArgs: [1, 1]);
  }
}
