import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gshala/const.dart';
import 'package:gshala/models/1_user_sqlite_model.dart';
import 'package:http/http.dart' as http;
import 'package:gshala/encryption.dart';

class LogInController extends GetxController {
  GetStorage box = new GetStorage();
  final userId = ''.obs;
  final password = ''.obs;
  final loginType = ''.obs;
  final userControl = ''.obs;
  final userLength = 0.obs;
  final userToggle = false.obs;
  final dropValue = ''.tr.obs;
  final isLoginSuccessful = false.obs;

  @override
  onInit() {
    userControl.listen((value) {
      if (userControl.value.length == 18) {
        dropValue.value = 'Student'.tr;
        print(dropValue.value);
        userToggle.value = true;
      } else if (userControl.value.length == 8) {
        dropValue.value = 'Teacher'.tr;
        print(dropValue.value);
        userToggle.value = true;
      } else {
        dropValue.value = '';
      }
    });
    super.onInit();
  }

  updateUserName(updatedValue) {
    userControl.value = updatedValue;
    update();
  }

  Future login() async {
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'APIKey': 'G12SHA98IZ82938KPP'
    };
    var request = http.Request('POST', Uri.parse(kloginapiurl));
    request.bodyFields = {
      'username': myEncryptionDecryption(
        box.read('userName'),
      ),
      'password': myEncryptionDecryption(
        box.read('password'),
      ),
      'grant_type': 'password',
      'scope': myEncryptionDecryption('Student'),
    };
    print(box.read('uType'));
    print(request.bodyFields);
    //loginType.value
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      print('login successful');
      isLoginSuccessful.value = true;
      var res = await response.stream.bytesToString();
      var data = UserResponse.fromJson(json.decode(res));
      print(data);
      box.write('accessToken', data.accessToken);
      box.write(
        'accessTokenTimeStamp',
        DateTime.now().toString(),
      );
    } else {
      print(response.statusCode);
      print(response.reasonPhrase);
    }
  }
}
