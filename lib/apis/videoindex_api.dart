// import 'dart:convert';
// import 'package:get_storage/get_storage.dart';
// import 'package:gshala/const.dart';
// import 'package:gshala/database/video_db.dart';
// import 'package:gshala/models/2.2_videoindex.dart';
// import 'package:http/http.dart' as http;

// class GetVideoIndexAPI {
//   GetStorage box = new GetStorage();
//   int std = 6;
//   double curVersion = 1.2;
//   Future getIndex() async {
//     var sendBody = await getDetails();
//     String autho = 'bearer ' + box.read('accessToken');
//     print(autho);
//     print(jsonEncode(sendBody));
//     var url = Uri.parse(
//         getIndexUrl + std.toString() + '&curVersion=' + curVersion.toString());
//     final response = await http.post(
//       url,
//       headers: {
//         'Content-Type': 'application/x-www-form-urlencoded',
//         "Authorization": autho,
//       },
//       body: jsonEncode(sendBody),
//     );

//     print(response.body);
//     if (response.statusCode == 200 || response.statusCode == 400) {
//       var data = videoIndexFromJson(json.decode(response.body));
//       return data;
//     } else {
//       print(response.statusCode);
//       throw Exception('Failed to signin');
//     }
//   }

//   getDetails() async {
//     final dbHelper = DatabaseProvider.db;
//     var data = await dbHelper.getVideoStatistics();
//     print(jsonEncode(data));
//     return data;
//   }

//   updateDatabase() async {
//     final dbHelper = DatabaseProvider.db;
//     await dbHelper.updateVideoDetails();
//     return print('Success');
//   }
// }
