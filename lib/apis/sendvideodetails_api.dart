import 'package:get/get.dart';
import 'package:gshala/const.dart';
import 'package:gshala/controllers/sendvideodetails_controller.dart';
import 'package:http/http.dart' as http;

class SendVideoDetailsApiService {
  final SendVideoDetailsController sendVideoDetailsApiService =
      Get.put(SendVideoDetailsController());
  Future sendVideoDetails() async {
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'APIKey': 'G12SHA98IZ82938KPP'
    };
    var request = http.Request('POST', Uri.parse(kloginapiurl));
    request.bodyFields = {
      'videoId': 'myEncryptionDecryption(userId.value)',
      'videoNamme': 'myEncryptionDecryption(password.value)',
      'videoLastPosition': 'password',
      'videoViews': 'myEncryptionDecryption(loginType.value)'
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
