import 'dart:io';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gshala/database/video_db.dart';
import 'package:gshala/models/2.1_videodownload_sqflite_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

class VideoListController extends GetxController {
  final listObtained = false.obs;
  final subjectListObtained = false.obs;
  final videoList = <VideoDownload>[].obs;
  final deleteVideo = false.obs;
  final thumbNailList = [].obs;
  final box = GetStorage();
  final filteredVideoList = <VideoDownload>[].obs;
  final subjectsList = [].obs;
  final filteredSubject = ''.obs;
  final isFiltered = false.obs;
  late VideoPlayerController videoPlayerController;
  final deletingVideo = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    videoList.clear();
    listObtained.value = false;
    super.onClose();
  }

  getVideosList() async {
    videoList.clear();
    Directory appDir = await getApplicationDocumentsDirectory();
    final videoDetails = await DatabaseProvider.db.getAllVideos();
    videoList.value = videoDetails;

    int userId = box.read('userId').runtimeType == int
        ? box.read('userId')
        : int.parse(
            box.read('userId'),
          );

    try {
      if (videoList.length > 0) {
        if (subjectListObtained.value == false) {
          print('Are subjects getting added');
          subjectsList.clear();
          subjectsList.add('All');
          videoList.forEach(
            (element) {
              subjectsList.add(element.subjectName!);
            },
          );
          subjectsList.value = subjectsList.toSet().toList();
          subjectListObtained.value = true;
          print(subjectsList);
        }
        // if a filtered is applied then the entire list should be returned
        filteredVideoList.clear();
        if (isFiltered.value == true) {
          if (filteredSubject.value == 'All') {
            filteredVideoList.addAll(videoList);
          } else {
            //'Filter by Subject'
            videoList.forEach(
              (element) {
                if (element.subjectName == filteredSubject.value) {
                  filteredVideoList.add(element);
                }
              },
            );
          }
        } else if (isFiltered.value == false) {
          //If no filter is applied then this is what it should return

          filteredVideoList.addAll(videoList);
        }

        //Update thumbnail list
        thumbNailList.clear();
        filteredVideoList.forEach((element) {
          String thumbName =
              element.videoName.toString().split('.').first + '.jpg';
          String thumbPath = appDir.path + '/videos/$userId/' + thumbName;
          thumbNailList.add(thumbPath);
        });
        listObtained.value = true;
      }
      return filteredVideoList;
    } catch (e) {
      listObtained.value = false;
      print(e);
    }
    update();
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
      File(appDir.path + '/videos/$userId/' + videoName + '.png').delete();
      print('Thumbnail Deleted');
    } catch (e) {
      print(e);
    }
  }
}
