import 'dart:io';

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

  static final DatabaseProvider db = DatabaseProvider._init();
  static Database? _database;
  DatabaseProvider._init();

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
        await database.execute(
          "CREATE TABLE $VIDEO_DOWNLOAD ("
          "$COLUMN_ID INTEGER PRIMARY KEY AUTOINCREMENT,"
          "$COLUMN_USER_ID INT NOT NULL,"
          "$COLUMN_VIDEO_ID INT NOT NULL,"
          "$COLUMN_LAST_POSTION INT NOT NULL,"
          "$COLUMN_VIDEO_NAME TEXT NOT NULL,"
          "$COLUMN_VIDEO_DELETED INT NOT NULL"
          ")",
        );
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

  //Get list of videos to display in offline mode
  Future<List<VideoDownload>> getVideos() async {
    final db = await database;
    final List<Map<String, dynamic>> vDownload = await db.query(VIDEO_DOWNLOAD);
    return vDownload.map((e) => VideoDownload.fromMap(e)).toList();
  }

  Future getAllVideos() async {
    final db = await database;
    List<Map<String, dynamic>> vList = await db.query(
      VIDEO_DOWNLOAD,
      where: '$COLUMN_VIDEO_DELETED = ?',
      whereArgs: [0],
    );
    print(vList.length);
    vList.forEach((element) {
      print('Element is $element');
    });
    return vList.map((e) => VideoDownload.fromMap(e)).toList();
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
        where: '$COLUMN_VIDEO_DATA_UPLOADED=?', whereArgs: [0]);

    return videoJsonFile.toList();
  }

  updateVideoDetails() async {
    final db = await database;
    return await db.rawUpdate(
      'UPDATE videoDetails SET videoDataUpdated = ? WHERE videoDataUpdated = ?',
      [1, 0],
    );
  }

  Future<int> updateDeleteVideoFlat(String videoName) async {
    final db = await database;
    print('Video deleted');
    print(videoName);
    int count = await db.rawUpdate(
      'UPDATE $VIDEO_DOWNLOAD SET $COLUMN_VIDEO_DELETED = ? WHERE $COLUMN_VIDEO_NAME = ?',
      [1, videoName],
    );
    print(count);
    return count;
  }

  //Close database
  Future closeDB() async {
    final db = await database;
    db.close();
  }

  // If file has been deleted from the database and details of usage have been uploaded on server then the file can be deleted from local path
  Future delete(String videoName) async {
    final db = await database;
    Directory appDir = await getApplicationDocumentsDirectory();
    File file = File(appDir.path + '/videos/' + videoName);
    file.exists().then((value) {
      file.delete();
    });
    return await db.delete(VIDEO_DOWNLOAD,
        where: "$COLUMN_VIDEO_DELETED = ?,$COLUMN_VIDEO_DATA_UPLOADED=?",
        whereArgs: [1, 1]);
  }
}
