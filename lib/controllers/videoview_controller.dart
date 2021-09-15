import 'dart:async';
import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gshala/database/video_db.dart';
import 'package:gshala/models/videodetails_sqflite_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

class PlayVideoController extends GetxController {
  late VideoPlayerController videoPlayerController;
  ChewieController? chewieController;
  final videoPosition = Duration.secondsPerDay.obs;
  final GetStorage box = new GetStorage();
  final videoDuration = 0.obs;
  final isVideoPlaying = false.obs;
  final dbHelper = DatabaseProvider.db;

  final currentStartPosition = 0.obs;
  final currentEndPosition = 0.obs;
  final currentTotalDuration = 0.obs;

  final videoPlayed = false.obs;
  final isFullScreen = false.obs;

  final vId = 0.obs;
  final vName = ''.obs;
  final vViewCounter = 0.obs;
  final vLastPosition = 0.obs;
  final vTotalViewDuration = 0.obs;

  @override
  void onInit() {
    super.onInit();
    initializePlayer();
  }

  @override
  void onClose() {
    print('test');
    videoPlayerController.dispose();
    chewieController!.dispose();
    box.remove('videoName');
  }

  // Initialize the player
  Future initializePlayer() async {
    final vInfo = await dbHelper.getSingleVideo(
      box.read('i'),
    );
    print(vInfo);
    vId.value = vInfo[0].id!;
    vName.value = vInfo[0].videoName!;
    vViewCounter.value = vInfo[0].videoViewCounter!;
    vLastPosition.value = vInfo[0].videoLastPosition!;
    Directory appDir = await getApplicationDocumentsDirectory();
    String appDirPath = appDir.path + '/videos/' + vName.value;
    print(appDirPath);
    videoPlayerController = VideoPlayerController.file(File(appDirPath));
    await Future.wait([
      videoPlayerController.initialize().then((value) {
        videoPlayerController.seekTo(
          Duration(seconds: vLastPosition.value),
        );
      }),
    ]);
    chewieController = ChewieController(
        videoPlayerController: videoPlayerController,
        autoPlay: false,
        looping: false,
        allowFullScreen: true,
        allowMuting: true,
        allowedScreenSleep: false,
        materialProgressColors: ChewieProgressColors(),
        showControlsOnInitialize: true,
        showOptions: true,
        showControls: true,
        placeholder: Container(
          color: Colors.black87,
        ),
        autoInitialize: true,
        additionalOptions: (context) {
          return <OptionItem>[];
        });
    trackVideoUpdate();
    update();
  }

  trackVideoUpdate() {
    videoPlayerController.addListener(() {
      if (chewieController!.isPlaying == false) {
        vTotalViewDuration.value =
            videoPlayerController.value.position.inSeconds;
      }
    });
  }

  videoUpdate() {
    videoPlayerController.play().then((value) {
      videoPlayerController.pause();
      isVideoPlaying.value = false;
    });
    if (videoPlayed.value == true) {
      vViewCounter.value = vViewCounter.value + 1;
      videoPlayed.value = false;
    }
    vLastPosition.value = videoPlayerController.value.position.inSeconds;
    vTotalViewDuration.value = vTotalViewDuration.value +
        videoPlayerController.value.position.inSeconds;
    final rowUpdate = VideoDetails(
      id: vId.value,
      videoName: vName.value,
      videoViewCounter: vViewCounter.value,
      videoLastPosition: vLastPosition.value,
      videoTotalViewDuration: vTotalViewDuration.value,
      videoDataUpdated: 0,
      videoDeleted: 0,
    );
    dbHelper.update(rowUpdate);
  }
}
