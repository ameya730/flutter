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
  final outOfFocus = false.obs;
  final dropValue = ''.tr.obs;

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
    print('scope is');
    print(loginType.value);
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'APIKey': 'G12SHA98IZ82938KPP'
    };
    var request = http.Request('POST', Uri.parse(kloginapiurl));
    request.bodyFields = {
      'username': myEncryptionDecryption(userId.value),
      'password': myEncryptionDecryption(password.value),
      'grant_type': 'password',
      'scope': myEncryptionDecryption('Student')
    };
    //loginType.value
    print(request.bodyFields);
    request.headers.addAll(headers);
    print(request);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var res = await response.stream.bytesToString();
      var data = UserResponse.fromJson(json.decode(res));
      box.write('accessToken', data.accessToken);
      print(box.read('accessToken'));
      box.write(
        'accessTokenTimeStamp',
        DateTime.now().toString(),
      );
      print(box.read('accessTokenTimeStamp'));
    } else {
      print(response.statusCode);
      print(response.reasonPhrase);
    }
  }
}
