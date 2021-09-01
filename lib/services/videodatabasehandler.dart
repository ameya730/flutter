// import 'package:get/get.dart';
// import 'package:gshala/models/videodetails_sqflite_model.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';

// class VideoDatabaseHandler extends GetxController {




//   Future<Database> initializeDB() async {
//     String path = await getDatabasesPath();
//     return openDatabase(
//       join(path, 'videoDetails.db'),
//       onCreate: (database, version) async {
//         await database.execute(
//           "CREATE TABLE videoDetails(id INTEGER PRIMARY KEY AUTOINCREMENT, videoName TEXT NOT NULL,videoViewCounter INTEGER NOT NULL,videoLastPosition INTEGER NOT NULL,videoTotalViewDuration INTEGER NOT NULL,)",
//         );
//       },
//       version: 1,
//     );
//   }

//   Future<int> insertUser(List<VideoDetails> videoDetails) async {
//     int result = 0;
//     final Database db = await initializeDB();
//     for (var video in videoDetails) {
//       result = await db.insert('videoDetails', video.toMap());
//     }
//     return result;
//   }

//   Future<List<VideoDetails>> getVideoDetails() async {
//     final Database db = await initializeDB();
//     final List<Map<String, Object?>> queryResult =
//         await db.query('videoDetails');
//     return queryResult.map((e) => VideoDetails.fromMap(e)).toList();
//   }

//   Future<void> deleteUser(int id) async {
//     final db = await initializeDB();
//     await db.delete(
//       'videoDetails',
//       where: "id = ?",
//       whereArgs: [id],
//     );
//   }
// }
