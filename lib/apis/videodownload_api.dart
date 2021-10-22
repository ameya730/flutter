import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gshala/const.dart';
import 'package:gshala/controllers/1.1_login_controller.dart';
import 'package:gshala/database/video_db.dart';
import 'package:http/http.dart' as http;

class DownloadVideoAPIService {
  GetStorage box = new GetStorage();
  Future sendVideoDetails() async {
    if (box.read('accessTokenTimeStamp').isBlank == true) {
      LogInController logInController = Get.put(LogInController());
      logInController.login();
    }
    DateTime tokenStartTime = DateTime.parse(
      box.read('accessTokenTimeStamp'),
    );
    int tokenActiveDuration =
        DateTime.now().difference(tokenStartTime).inSeconds;
    if (tokenActiveDuration > 160) {
      LogInController logInController = Get.put(LogInController());
      logInController.login();
    }

    var sendBody = await getDetails();
    String autho = 'bearer ' + box.read('accessToken');
    var url = Uri.parse(sendVideoDetailsUrl);
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": autho,
      },
      body: jsonEncode(sendBody),
    );
    if (response.statusCode == 200 || response.statusCode == 400) {
      updateDatabase();
      return json.decode(response.body);
    } else {
      throw Exception('Failed to signin');
    }
  }

  getDetails() async {
    final dbHelper = DatabaseProvider.db;
    var data = await dbHelper.getVideoStatistics();
    return data;
  }

  updateDatabase() async {
    final dbHelper = DatabaseProvider.db;
    await dbHelper.updateVideoDetails();
  }
}
