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
  final duplicateCount = false.obs;
  final messageReceived = false.obs;
  GetStorage box = new GetStorage();
  final LogInController logInController = Get.put(LogInController());
  CancelToken cancelToken = new CancelToken();
  Dio dio = Dio();

  Future<void> downloadFile(VideoDownloaded videoDetails) async {
    try {
      //Revalidate access token and get a new one if required
      if (box.read('accessTokenTimeStamp') != null) {
        DateTime tokenStartTime = DateTime.parse(
          box.read('accessTokenTimeStamp'),
        );
        int tokenActiveDuration =
            DateTime.now().difference(tokenStartTime).inSeconds;
        if (tokenActiveDuration > 160) {
          await logInController.login();
        }
      }

      //Get video URL
      videoURL.value = videoDetails.vidUrl.toString();
      //Get android download directory
      Directory appDir = await getApplicationDocumentsDirectory();
      //Define path
      String imgUrl = videoDownloadURL + videoURL.value;
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
      print('The authorization token is');
      print(autho);
      isdownloading.value = true;

      // Download the video
      await dio.download(imgUrl, "${appDir.path}/videos/$videoName",
          cancelToken: cancelToken,
          options: Options(headers: {
            "Content-Type": "application/x-www-form-urlencoded",
            // "Access-Control-Allow-Origin": "*",
            // "APIKey": "G12SHA98IZ82938KPP",
            "Authorization": autho
          }), onReceiveProgress: (rec, total) {
        progressPercentage.value = (rec / total);
        progressString.value = ((rec / total) * 100).toStringAsFixed(0) + "%";
      }).then((value) {
        progressString.value = '';
        progressPercentage.value = 0.0;
      });
      await VideoThumbnail.thumbnailFile(
        video: '${appDir.path}/videos/$videoName',
        imageFormat: ImageFormat.JPEG,
        maxWidth: 0,
        quality: 50,
      );
      //Insert data in the database
      await DatabaseProvider.db.insertNewVideo(videoDownload);
      downloadComplete.value = true;
    } catch (e) {
      print(e);
    }
  }

  stopDownload() {
    cancelToken.cancel();
  }
}
