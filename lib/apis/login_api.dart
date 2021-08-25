import 'dart:convert';
import 'package:get/get.dart';
import 'package:gshala/const.dart';
import 'package:gshala/controllers/login_controller.dart';
import 'package:http/http.dart' as http;

class LoginApiService {
  final LogInController logInController = Get.put(LogInController());

  Future login() async {
    var url = Uri.parse(loginApiUrl);
    var response =
        await http.post(url, body: logInController.toJson(), headers: {
      "Accept": "application/json",
      "Access-Control-Allow-Origin": "*",
    });
    if (response.statusCode == 200 || response.statusCode == 400) {
      var data = jsonDecode(response.body);
      print(data);
      return data;
    } else {
      throw Exception('Failed to sign-in');
    }
  }
}
