import 'dart:io';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gshala/const.dart';
import 'package:gshala/controllers/1.1_login_controller.dart';
import 'package:gshala/database/video_db.dart';
import 'package:gshala/models/2.1_videodownload_sqflite_model.dart';
import 'package:gshala/models/3.0_videodownload_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class VideoDownloadController extends GetxController {
  final videoURL = ''.obs;
  final videoName = ''.obs;
  final isdownloading = false.obs;
  final progressString = ''.obs;
  final progressPercentage = 0.0.obs;
  final downloadComplete = false.obs;
  Dio dio = Dio();

  Future<void> downloadFile(VideoDownloaded videoDetails) async {
    try {
      GetStorage box = new GetStorage();

      //Revalidate access token and get a new one if required
      DateTime tokenStartTime = DateTime.parse(
        box.read('accessTokenTimeStamp'),
      );
      int tokenActiveDuration =
          DateTime.now().difference(tokenStartTime).inSeconds;
      print('Time lapsed is " $tokenActiveDuration');
      if (tokenActiveDuration > 160) {
        print('gettin token again');
        LogInController logInController = Get.put(LogInController());
        logInController.login();
      }
      print(box.read('accessToken'));

      //Get video URL
      videoURL.value = videoDetails.vidUrl.toString();

      //Get android download directory
      Directory appDir = await getApplicationDocumentsDirectory();

      print(videoURL.value);
      //Define path
      String imgUrl = videoDownloadURL + videoURL.value;
      // videoDownloadURL + videoURL.value;
      print('The video path is');
      print(imgUrl);
      String videoName = imgUrl.split('/').last;
      final videoDownload = VideoDownload(
        userId: 0,
        resourceNodeId: 0,
        videoName: videoName,
        videoLastViewPosition: 0,
        videoDeleted: 0,
        videoId: videoDetails.nodeid,
        videoURL: videoDetails.vidUrl,
        nodeName: videoDetails.nodename,
        chapter: videoDetails.chapter,
        videoClass: videoDetails.videoDownloadedClass,
        subjectName: videoDetails.subjectName,
        topic: videoDetails.topic,
      );

      //Set-up authorization

      String autho = 'Bearer ' + box.read('accessToken');
      print(autho);
      isdownloading.value = true;
      // Download the video
      await dio.download(imgUrl, "${appDir.path}/videos/$videoName",
          options: Options(headers: {
            "Content-Type": "application/x-www-form-urlencoded",
            // "Access-Control-Allow-Origin": "*",
            // "APIKey": "G12SHA98IZ82938KPP",
            "Authorization": autho
          }), onReceiveProgress: (rec, total) {
        progressPercentage.value = (rec / total);
        progressString.value = ((rec / total) * 100).toStringAsFixed(0) + "%";
      }).then((value) {
        VideoThumbnail.thumbnailFile(
          video: '${appDir.path}/videos/$videoName',
          imageFormat: ImageFormat.JPEG,
          maxWidth: 0,
          quality: 50,
        );
        //Insert data in the database
        DatabaseProvider.db.insertNewVideo(videoDownload);
        downloadComplete.value = true;
      });
    } catch (e) {
      print(e);
    }
  }
}
