import 'dart:async';
import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gshala/database/video_db.dart';
import 'package:gshala/models/2.0_videodetails_sqflite_model.dart';
import 'package:gshala/models/2.1_videodownload_sqflite_model.dart';
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

  final vName = ''.obs;
  final currentStartPosition = 0.obs;
  final currentEndPosition = 0.obs;
  final currentTotalDuration = 0.obs;

  final videoPlayed = false.obs;
  final isFullScreen = false.obs;

  final vId = 0.obs;

  @override
  void onInit() {
    super.onInit();
    initializePlayer();
  }

  @override
  void onClose() {
    videoPlayerController.dispose();
    chewieController!.dispose();
    box.remove('videoName');
  }

  // Initialize the player
  Future initializePlayer() async {
    List<VideoDownload> vidDetails = await dbHelper.getSingleVideo(
      box.read('videoName'),
    );
    print(vidDetails[0].videoLastViewPosition);
    vName.value = box.read('videoName');
    currentStartPosition.value = vidDetails[0].videoLastViewPosition!;
    Directory appDir = await getApplicationDocumentsDirectory();
    String appDirPath = appDir.path + '/videos/' + vName.value;
    videoPlayerController = VideoPlayerController.file(File(appDirPath));
    await Future.wait([
      videoPlayerController.initialize().then((value) {
        videoPlayerController.seekTo(
          Duration(seconds: currentStartPosition.value),
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
        currentEndPosition.value =
            videoPlayerController.value.position.inSeconds;
      }
    });
  }

  videoUpdate() {
    if (chewieController!.isPlaying == true) {
      videoPlayerController.pause();
    }
    currentTotalDuration.value =
        currentEndPosition.value - currentStartPosition.value;
    dbHelper.updateVideoLastPosition(
      videoPlayerController.value.position.inSeconds,
      box.read('videoName'),
    );

    final row = VideoDetails(
      userId: 0,
      lessonPlanId: 0,
      resourceNodeId: 0,
      docType: 'video',
      videoInitializeDate: DateTime.now().toString(),
      videoDuration: videoPlayerController.value.duration.inSeconds,
      videoStartTime: currentStartPosition.value,
      videoEndTime: currentEndPosition.value,
      videoViewDate: DateTime.now().toString(),
      videoViewCompleted: 0,
      videoViewCompletedDate: DateTime.now().toString(),
      videoTotalViewDuration: currentTotalDuration.value,
      videoName: box.read('videoName'),
      videoDataUpdated: 0,
      videoDeleted: 0,
    );
    dbHelper.insertVideoStatistics(row);
  }
}
