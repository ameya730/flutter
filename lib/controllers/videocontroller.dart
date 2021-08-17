import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:video_player/video_player.dart';

class VideoControllerGetX extends GetxController {
  late VideoPlayerController videoPlayerController;
  ChewieController? chewieController;
  final videoPosition = Duration.secondsPerDay.obs;
  final GetStorage box = new GetStorage();
  final videoDuration = "0:00:00.0000".obs;
  @override
  void onInit() {
    super.onInit();
    initializePlayer();
  }

  @override
  void onClose() {
    videoDuration.value = videoPlayerController.value.position.toString();
    videoPlayerController.dispose();
    chewieController!.dispose();
  }

  Future<void> initializePlayer() async {
    videoPlayerController =
        VideoPlayerController.asset('assets/VID_20210811_104944.mp4');
    await Future.wait([
      videoPlayerController.initialize().then((value) {
        print(videoDuration.value);
      }),
    ]);
    await Future.wait([
      videoPlayerController.pause().then((value) {
        videoPlayerController.addListener(() {
          videoDuration.value = videoPlayerController.position.toString();
        });
      })
    ]);
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: false,
      looping: true,
      allowFullScreen: true,
      allowMuting: true,
      allowedScreenSleep: false,
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.red,
        backgroundColor: Colors.yellow,
        bufferedColor: Colors.green.shade100,
      ),
      showControlsOnInitialize: true,
      showOptions: true,
      showControls: true,
      placeholder: Container(
        color: Colors.greenAccent,
      ),
      autoInitialize: true,
    );
    update();
  }
}
