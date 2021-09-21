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
    DateTime tokenStartTime = DateTime.parse(
      box.read('accessTokenTimeStamp'),
    );
    int tokenActiveDuration =
        DateTime.now().difference(tokenStartTime).inSeconds;
    print('Time lapsed is " $tokenActiveDuration');
    if (tokenActiveDuration > 160) {
      LogInController logInController = Get.put(LogInController());
      logInController.login();
      print('token retrived again');
    }

    var sendBody = await getDetails();
    String autho = 'bearer ' + box.read('accessToken');
    print(autho);
    print(jsonEncode(sendBody));
    var url = Uri.parse(sendVideoDetailsUrl);
    final response = await http.post(
      url,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Access-Control-Allow-Origin": "*",
        "APIKey": "G12SHA98IZ82938KPP",
        "Authorization": autho,
      },
      body: jsonEncode(sendBody),
    );

    print(response.body);
    if (response.statusCode == 200 || response.statusCode == 400) {
      updateDatabase();
      return json.decode(response.body);
    } else {
      print(response.statusCode);
      throw Exception('Failed to signin');
    }
  }

  getDetails() async {
    final dbHelper = DatabaseProvider.db;
    var data = await dbHelper.getVideoStatistics();
    print(jsonEncode(data));
    return data;
  }

  updateDatabase() async {
    final dbHelper = DatabaseProvider.db;
    await dbHelper.updateVideoDetails();
    return print('Success');
  }
}
