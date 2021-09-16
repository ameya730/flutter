import 'dart:convert';
import 'package:get/get.dart';
import 'package:gshala/controllers/0.0_sendvideodetails_controller.dart';
import 'package:gshala/database/video_db.dart';
import 'package:http/http.dart' as http;

class SendVideoDetailsApiService {
  final SendVideoDetailsController sendVideoDetailsController =
      Get.put(SendVideoDetailsController());

  Future sendVideoDetails() async {
    var sendBody = await getDetails();
    var url = Uri.parse('uri');
    final response = await http.post(
      url,
      headers: {
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*",
      },
      body: jsonEncode(sendBody),
    );

    print(response.body);
    if (response.statusCode == 200 || response.statusCode == 400) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to signin');
    }
  }

  getDetails() async {
    final dbHelper = DatabaseProvider.db;
    var data = await dbHelper.getVideoStatistics();
    print(jsonEncode(data));
    return data;
  }
}
