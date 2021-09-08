import 'package:get/get.dart';
import 'package:gshala/const.dart';
import 'package:http/http.dart' as http;
import 'package:gshala/encryption.dart';

class LogInController extends GetxController {
  final userId = ''.obs;
  final password = ''.obs;
  final loginType = ''.obs;

  Future login() async {
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'APIKey': 'G12SHA98IZ82938KPP'
    };
    var request = http.Request('POST', Uri.parse(kloginapiurl));
    request.bodyFields = {
      'username': myEncryptionDecryption(userId.value),
      'password': myEncryptionDecryption(password.value),
      'grant_type': 'password',
      'scope': myEncryptionDecryption(loginType.value)
    };
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }
}
