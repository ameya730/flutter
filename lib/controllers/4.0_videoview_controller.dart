import 'dart:async';
import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gshala/controllers/2.1_videolist_controller.dart';
import 'package:gshala/database/video_db.dart';
import 'package:gshala/models/2.0_videodetails_sqflite_model.dart';
import 'package:gshala/models/2.1_videodownload_sqflite_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

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
  final isComplete = false.obs;
  final actuallyComplete = false.obs;

  final videoPlayed = false.obs;
  final isFullScreen = false.obs;

  final vId = 0.obs;
  final StopWatchTimer _stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countUp,
    onChangeRawSecond: (value) {
      print('onChangeRawSecond $value');
    },
  );
  @override
  void onInit() {
    super.onInit();
    // secureScreen();
    initializePlayer();
  }

  @override
  void onClose() {
    videoPlayerController.dispose();
    chewieController!.dispose();
    _stopWatchTimer.dispose();
    box.remove('videoName');
  }

  // Initialize the player
  Future initializePlayer() async {
    int userId = int.parse(
      box.read('userId'),
    );
    _stopWatchTimer.onExecute.add(StopWatchExecute.reset);
    List<VideoDownload> vidDetails = await dbHelper.getSingleVideo(
      box.read('videoName'),
    );

    print(vidDetails[0].videoLastViewPosition);
    vName.value = box.read('videoName');
    currentStartPosition.value = vidDetails[0].videoLastViewPosition!;
    Directory appDir = await getApplicationDocumentsDirectory();
    String appDirPath = appDir.path + '/videos/$userId/' + vName.value;
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
      showOptions: false,
      allowedScreenSleep: false,
      materialProgressColors: ChewieProgressColors(),
      showControlsOnInitialize: true,
      showControls: true,
      fullScreenByDefault: true,
      overlay: Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 4.0,
            top: 4.0,
          ),
          child: Image.asset(
            'assets/videooverlay.png',
            height: 15,
          ),
        ),
      ),
      placeholder: Container(
        color: Colors.black87,
      ),
      autoInitialize: true,
    );
    trackVideoUpdate();
    update();
  }

  trackVideoUpdate() {
    videoPlayerController.addListener(
      () {
        if (chewieController!.isPlaying == false) {
          _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
          currentTotalDuration.value =
              StopWatchTimer.getRawSecond(_stopWatchTimer.rawTime.value);
          print('Total Duration is : $currentTotalDuration.value');
          currentEndPosition.value =
              videoPlayerController.value.position.inSeconds;
        }
        if (chewieController!.isPlaying == true) {
          _stopWatchTimer.onExecute.add(StopWatchExecute.start);
          _stopWatchTimer.secondTime.listen((value) {
            print('Current time is $value');
          });
          if (videoPlayerController.value.duration ==
              videoPlayerController.value.position) {
            isComplete.value = true;
          }
        }
        if (chewieController!.isFullScreen) {
          isFullScreen.value = true;
          print(isFullScreen.value);
        } else {
          isFullScreen.value = false;
          print(isFullScreen.value);
        }
      },
    );
  }

  videoUpdate() {
    final videoListController = Get.put(VideoListController());
    int i = box.read('i');
    if (chewieController!.isPlaying == true) {
      videoPlayerController.pause();
    }
    dbHelper.updateVideoLastPosition(
      videoPlayerController.value.position.inSeconds,
      box.read('videoName'),
    );

    if (isComplete.value == true &&
        currentTotalDuration.value >=
            videoPlayerController.value.duration.inSeconds) {
      actuallyComplete.value = true;
    } else {
      actuallyComplete.value = false;
    }

    final row = VideoDetails(
      userId: videoListController.filteredVideoList[i].userId,
      lessonPlanId: 0,
      resourceNodeId: videoListController.filteredVideoList[i].resourceNodeId,
      docType: 'video',
      videoInitializeDate: DateTime.now().toString(),
      videoDuration: videoPlayerController.value.duration.inSeconds,
      videoStartTime: currentStartPosition.value,
      videoEndTime: currentEndPosition.value,
      videoViewDate: DateTime.now().toString(),
      videoViewCompleted: actuallyComplete.value ? 1 : 0,
      videoViewCompletedDate: DateTime.now().toString(),
      videoTotalViewDuration: currentTotalDuration.value,
      videoName: box.read('videoName'),
      videoDataUpdated: 0,
      videoDeleted: 0,
    );
    dbHelper.insertVideoStatistics(row);
  }
}
