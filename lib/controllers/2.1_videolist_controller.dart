import 'dart:io';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gshala/database/video_db.dart';
import 'package:gshala/models/2.1_videodownload_sqflite_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

class VideoListController extends GetxController {
  final listObtained = false.obs;
  final videoLink = ''.obs;
  final index = 0.obs;
  late VideoPlayerController videoPlayerController;
  final videoList = <VideoDownload>[].obs;
  final deleteVideo = false.obs;
  final thumbNailList = [].obs;
  final box = GetStorage();
  final filteredVideoList = <VideoDownload>[].obs;
  final subjectsList = [].obs;
  final filteredSubject = ''.obs;
  final isFiltered = false.obs;
  final videoListObtained = false.obs;

  @override
  void onInit() {
    getVideosList();
    super.onInit();
  }

  @override
  void onClose() {
    videoList.clear();
    videoListObtained.value = false;
    super.onClose();
  }

  deleteVideoFromFile(String videoName) async {
    try {
      int userId = int.parse(
        box.read('userId'),
      );
      final appDir = await getApplicationDocumentsDirectory();
      File(appDir.path + '/videos/$userId/' + videoName + '.mp4').delete();
      print('Video Deleted');
    } catch (e) {
      print(e);
    }
  }

  deleteThumbNailFromFile(String videoName) async {
    try {
      int userId = int.parse(
        box.read('userId'),
      );
      final appDir = await getApplicationDocumentsDirectory();
      File(appDir.path + '/videos/$userId/' + videoName + '.jpg').delete();
      print('Thumbnail Deleted');
    } catch (e) {
      print(e);
    }
  }

  Future getVideosList() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    if (videoListObtained.value == false) {
      final videoDetails = await DatabaseProvider.db.getAllVideos();
      videoList.value = videoDetails;
      videoListObtained.value = true;
    }

    int userId = int.parse(
      box.read('userId'),
    );
    if (subjectsList.isEmpty) {
      subjectsList.add('All');
    }
    try {
      if (videoList.length > 0) {
        videoList.forEach((element) {
          subjectsList.add(element.subjectName);
        });
        subjectsList.value = subjectsList.toSet().toList();
        print(subjectsList);
        if (filteredSubject.value == '') {
          videoList.forEach((element) {
            String thumbName =
                element.videoName.toString().split('.').first + '.jpg';
            String thumbPath = appDir.path + '/videos/$userId/' + thumbName;
            thumbNailList.add(thumbPath);
          });
          filteredVideoList.addAll(videoList);
        } else if (filteredSubject.value == 'All') {
          filteredVideoList.clear();
          videoList.forEach((element) {
            String thumbName =
                element.videoName.toString().split('.').first + '.jpg';
            String thumbPath = appDir.path + '/videos/$userId/' + thumbName;
            thumbNailList.add(thumbPath);
          });
          filteredVideoList.addAll(videoList);
        } else {
          filteredVideoList.clear();
          videoList.forEach((element) {
            if (element.subjectName == filteredSubject.value) {
              filteredVideoList.add(element);
              String thumbName =
                  element.videoName.toString().split('.').first + '.jpg';
              String thumbPath = appDir.path + '/videos/$userId/' + thumbName;
              thumbNailList.add(thumbPath);
            }
          });
        }
        listObtained.value = true;
      } else {
        listObtained.value = false;
      }

      return filteredVideoList;
    } catch (e) {
      print(e);
    }
    update();
  }
}
