import 'dart:io';
import 'package:get/get.dart';
import 'package:gshala/const.dart';
import 'package:gshala/database/video_db.dart';
import 'package:gshala/models/videodetails_sqflite_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class VideoDownloadController extends GetxController {
  final videoName = ''.obs;
  final isdownloading = false.obs;
  final progressString = ''.obs;
  final progressPercentage = 0.0.obs;
  final downloadComplete = false.obs;
  Dio dio = Dio();

  Future<void> downloadFile() async {
    try {
      Directory appDir = await getApplicationDocumentsDirectory();
      String imgUrl = videoTestExample;
      print(appDir);
      print(imgUrl);
      isdownloading.value = true;
      String videoName = imgUrl.split('/').last;
      print(videoName);
      final videoDetails = VideoDetails(
        videoName: videoName,
        videoLastPosition: 0,
        videoViewCounter: 0,
        videoTotalViewDuration: 0,
        videoDataUpdated: 0,
        videoDeleted: 0,
      );
      print(videoDetails);
      DatabaseProvider.db.insert(videoDetails);
      await dio.download(imgUrl, "${appDir.path}/videos/$videoName",
          onReceiveProgress: (rec, total) {
        progressPercentage.value = (rec / total);
        progressString.value = ((rec / total) * 100).toStringAsFixed(0) + "%";
      });
      await VideoThumbnail.thumbnailFile(
        video: '${appDir.path}/videos/$videoName',
        imageFormat: ImageFormat.JPEG,
        maxWidth: 0,
        quality: 50,
      );
      downloadComplete.value = true;
    } catch (e) {
      print(e);
    }
  }
}
