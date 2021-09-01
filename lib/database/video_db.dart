import 'package:gshala/models/videodetails_sqflite_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  static const String VIDEO_DETAILS = "videoDetails";
  static const String COLUMN_ID = "id";
  static const String COLUMN_VIDEO_NAME = "videoName";
  static const String COLUMN_VIDEO_VIEW_COUNT = "videoViewCounter";
  static const String COLUMN_LAST_POSITION = "videoLastPosition";
  static const String COLUMN_TOTAL_VIEW_DURATION = "videoTotalViewDuration";
  static const String COLUMN_VIDEO_DATA_UPLOADED = "videoDataUpdated";
  static const String COLUMN_VIDEO_DELETED = "videoDeleted";

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
          "CREATE TABLE $VIDEO_DETAILS ("
          "$COLUMN_ID INTEGER PRIMARY KEY AUTOINCREMENT,"
          "$COLUMN_VIDEO_NAME STRING,"
          "$COLUMN_VIDEO_VIEW_COUNT INT,"
          "$COLUMN_TOTAL_VIEW_DURATION INT,"
          "$COLUMN_LAST_POSITION INT,"
          "$COLUMN_VIDEO_DATA_UPLOADED INT,"
          "$COLUMN_VIDEO_DELETED INT"
          ")",
        );
      },
    );
  }

  Future<List<VideoDetails>> getVideos() async {
    final db = await database;
    final List<Map<String, Object?>> vDetails = await db.query(VIDEO_DETAILS);
    return vDetails.map((e) => VideoDetails.fromMap(e)).toList();
  }

  Future closeDB() async {
    final db = await database;
    db.close();
  }

  Future<VideoDetails> insert(VideoDetails videoDetails) async {
    final db = await database;
    videoDetails.id = await db.insert(VIDEO_DETAILS, videoDetails.toMap());
    return videoDetails;
  }

  Future<int> update(VideoDetails videoDetails) async {
    final db = await database;
    return await db.update(
      VIDEO_DETAILS,
      videoDetails.toMap(),
      where: "id = ?",
      whereArgs: [videoDetails.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await database;
    return await db.delete(VIDEO_DETAILS, where: "id = ?", whereArgs: [id]);
  }
}
