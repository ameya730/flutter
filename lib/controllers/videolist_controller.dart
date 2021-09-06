import 'package:get/get.dart';
import 'package:gshala/database/video_db.dart';
import 'package:gshala/models/videodetails_sqflite_model.dart';
import 'package:video_player/video_player.dart';

class VideoListController extends GetxController {
  final listObtained = false.obs;
  final videoLink = ''.obs;
  final index = 0.obs;
  late VideoPlayerController videoPlayerController;
  final videoList = <VideoDetails>[].obs;
  final deleteVideo = false.obs;
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
    try {
      final videoDetails = await DatabaseProvider.db.getVideos();
      print(videoDetails.length);
      if (index.value != videoDetails.length) {
        videoList.value = videoDetails;
        listObtained.value = true;
      }
      print(videoList.length);
      return videoList;
    } catch (e) {
      print(e);
    }
    update();
  }
}
