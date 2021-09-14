import 'dart:io';

import 'package:get/get.dart';
import 'package:gshala/database/video_db.dart';
import 'package:gshala/models/videodetails_sqflite_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

class VideoListController extends GetxController {
  final listObtained = false.obs;
  final videoLink = ''.obs;
  final index = 0.obs;
  late VideoPlayerController videoPlayerController;
  final videoList = <VideoDetails>[].obs;
  final deleteVideo = false.obs;
  final thumbNailList = [].obs;

  @override
  void onInit() {
    getVideosList();
    super.onInit();
  }

  @override
  void onClose() {
    videoList.clear();
    super.onClose();
  }

  Future getVideosList() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    Directory vDir = Directory(appDir.path + '/videos');
    List list = [];
    vDir.list(recursive: false).forEach((element) {
      print(element);
      list.add(element.path);
    });
    print('List of files are');
    print(list);
    try {
      final videoDetails = await DatabaseProvider.db.getVideos();
      print(videoDetails.length);
      if (index.value != videoDetails.length) {
        videoList.value = videoDetails;
        listObtained.value = true;
      }
      videoList.forEach((element) {
        String thumbName =
            element.videoName.toString().split('.').first + '.jpg';

        String thumbPath = appDir.path + '/videos/' + thumbName;
        print(thumbPath);
        thumbNailList.add(thumbPath);
      });
      return videoList;
    } catch (e) {
      print(e);
    }
    update();
  }
}
