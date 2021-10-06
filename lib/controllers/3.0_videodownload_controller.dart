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
  final downloadInProgress = false.obs;

  GetStorage box = new GetStorage();
  final LogInController logInController = Get.put(LogInController());
  Dio dio = Dio();
  CancelToken cancelToken = new CancelToken();

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> downloadFile(VideoDownloaded videoDetails) async {
    isdownloading.value = true;
    downloadInProgress.value = false;
    print(downloadInProgress.value);

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
        userId: int.parse(box.read('userId')),
        resourceNodeId: 0,
        videoLastViewPosition: 0,
        videoName: videoName,
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
      int userId = int.parse(
        box.read('userId'),
      );

      //Reinitialize cancel token
      if (cancelToken.isCancelled) {
        cancelToken = new CancelToken();
      }

      print('The video name is $videoName');
      // Download the video
      await dio.download(
        imgUrl,
        "${appDir.path}/videos/$userId/$videoName",
        cancelToken: cancelToken,
        deleteOnError: true,
        options: Options(
          headers: {
            "Content-Type": "application/x-www-form-urlencoded",
            "Authorization": autho
          },
        ),
        onReceiveProgress: (rec, total) {
          if (rec > 0) {
            downloadInProgress.value = true;
          }
          progressPercentage.value = (rec / total);
          progressString.value = ((rec / total) * 100).toStringAsFixed(0) + "%";
          if (rec == total) {
            rec = 0;
            total = 0;
          }
        },
      );

      //Download thumbnail
      String thumbNail = videoDetails.nodename!.replaceAll('mp4', 'jpg');
      String thumbNailURL = videoURL.value.replaceAll('.mp4', '.png');
      thumbNailURL = thumbNailURL.replaceAll('mp4', 'thumbnail');
      print(thumbNail);
      print(thumbNailURL);

      await dio.download(
        thumbNailURL,
        "${appDir.path}/videos/$userId/$thumbNail",
        cancelToken: cancelToken,
        deleteOnError: true,
      );

      //Insert data in the database
      await DatabaseProvider.db.insertNewVideo(videoDownload);
      downloadComplete.value = true;
      progressPercentage.value = 0.0;
      progressString.value = '';
      print('download complete');
    } catch (e) {
      downloadInProgress.value = false;
      downloadComplete.value = false;
      isdownloading.value = false;
      print(e);
    }
  }

  cancelDownload() {
    downloadInProgress.value = false;
    isdownloading.value = false;
    downloadComplete.value = false;
    progressPercentage.value = 0.0;
    progressString.value = '';
    cancelToken.cancel();
    update();
  }
}
