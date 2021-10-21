import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:gshala/apis/sendvideodetails_api.dart';
import 'package:gshala/controllers/6.0_videoviewpage_controller.dart';
import 'package:gshala/database/video_db.dart';
import 'package:gshala/getxnetworkmanager.dart';

sendVideoStatistics() {
  SendVideoDetailsApiService sendVideoDetailsApiService =
      new SendVideoDetailsApiService();
  final videoViewPageOpenController = Get.put(VideoViewPageOpenController());
  final networkManager = Get.put(GetXNetworkManager());
  final dbHelper = DatabaseProvider.db;
  const oneSec = Duration(seconds: 10);
  Timer.periodic(
    oneSec,
    (Timer t) async {
      List data = await dbHelper.getVideoStatistics();
      if (data.isEmpty == false &&
          videoViewPageOpenController.isvideoViewPageOpen.value == false &&
          networkManager.connectionPresent.value == true) {
        var videoData = json.encode(data);
        print(videoData);
        print(videoData.runtimeType);
        sendVideoDetailsApiService.sendVideoDetails(videoData).then(
          (value) {
            dbHelper.updateVideoDetails();
            print('Data sent successfully');
            // dbHelper.updateDetails();
          },
        );
      }
    },
  );
}
