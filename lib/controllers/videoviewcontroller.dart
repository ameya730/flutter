import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

class VideoControllerGetX extends GetxController {
  late VideoPlayerController videoPlayerController;
  ChewieController? chewieController;
  final videoPosition = Duration.secondsPerDay.obs;
  final GetStorage box = new GetStorage();
  final videoDuration = 0.obs;
  final isVideoPlaying = false.obs;

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

  void toggleVideoPlay() {
    if (isVideoPlaying.value == true) {
      isVideoPlaying.value = false;
      videoPlayerController.pause().then((value) {
        print(videoPlayerController.value.position.inSeconds);
        box.write('vPosition', videoPlayerController.value.position.inSeconds);
      });
    } else if (isVideoPlaying.value == false) {
      isVideoPlaying.value = true;
      videoPlayerController.play().then((value) {
        if (box.read('vPosition') != 0) {
          videoPlayerController.seekTo(
            box.read('vPosition'),
          );
        }
      });
    }
  }

  Future initializePlayer() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    print(box.read('videoName'));
    String appDirPath = appDir.path + '/videos/' + box.read('videoName');
    videoPlayerController = VideoPlayerController.file(File(appDirPath));
    await Future.wait([
      videoPlayerController.initialize(),
    ]);
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: false,
      looping: false,
      allowFullScreen: true,
      allowMuting: true,
      allowedScreenSleep: false,
      materialProgressColors: ChewieProgressColors(
          // playedColor: Colors.red,
          // backgroundColor: Colors.yellow,
          // bufferedColor: Colors.green.shade100,
          ),
      showControlsOnInitialize: false,
      showOptions: false,
      showControls: false,
      placeholder: Container(
        color: Colors.black87,
      ),
      autoInitialize: true,
    );
    update();
  }
}
