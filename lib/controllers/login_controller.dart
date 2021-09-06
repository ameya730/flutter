import 'dart:convert';

import 'package:get/get.dart';
import 'package:gshala/const.dart';
import 'package:http/http.dart' as http;

class LogInController extends GetxController {
  final userId = ''.obs;
  final password = ''.obs;
  final loginType = ''.obs;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'username': userId.value,
      'password': password.value,
      'loginType': loginType.value,
    };
    print(map);
    return map;
  }

  Future login() async {
    var url = Uri.parse(kloginapiurl);
    final response = await http.post(url,
        headers: {
          "Accept": "application/json",
          "Access-Control-Allow-Origin": "*",
          "Content-Type": "application/x-www-form-urlencoded",
          "APIKey": "G12SHA98IZ82938KPP",
        },
        body: toJson());
    if (response.statusCode == 200 || response.statusCode == 400) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to signin');
    }
  }
}
