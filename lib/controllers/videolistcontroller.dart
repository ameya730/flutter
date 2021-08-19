import 'dart:io';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

class VideoListController extends GetxController {
  final listObtained = false.obs;
  final videoLink = ''.obs;
  late VideoPlayerController videoPlayerController;
  List<FileSystemEntity> videoList = <FileSystemEntity>[].obs;
  @override
  void onInit() {
    getVideosList();
    super.onInit();
  }

  Future getVideosList() async {
    try {
      var dir = await getApplicationDocumentsDirectory();
      final videoDir = new Directory(dir.path + '/videos/');
      videoList = videoDir
          .listSync(
            recursive: false,
          )
          .toList();
      if (videoList.isEmpty == false) {
        listObtained.value = true;
        print(videoList);
        return videoList;
      }
    } catch (e) {
      print(e);
    }
  }
}
