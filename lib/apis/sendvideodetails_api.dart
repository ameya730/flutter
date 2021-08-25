import 'package:get/get.dart';
import 'package:gshala/const.dart';
import 'package:gshala/controllers/sendvideodetails_controller.dart';
import 'package:http/http.dart' as http;

class SendVideoDetailsApiService {
  final SendVideoDetailsController sendVideoDetailsApiService =
      Get.put(SendVideoDetailsController());
  Future sendDetails() async {
    var url = Uri.parse(sendVideoDetailsUrl);
    var response = await http.post(
      url,
      headers: {
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*",
      },
      body: sendVideoDetailsApiService.toJson(),
    );
    if (response.statusCode == 200 || response.statusCode == 400) {
      var data = response.body;
      return data;
    } else {
      throw Exception('Failed to push video data');
    }
  }
}
