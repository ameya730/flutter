import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gshala/controllers/videocontroller.dart';
import 'package:gshala/controllers/videodownloadcontroller.dart';
import 'package:gshala/templates/custombutton.dart';
import 'package:video_player/video_player.dart';

class ViewVideoPage extends StatelessWidget {
  final VideoControllerGetX vController = Get.put(VideoControllerGetX());
  final VideoDownloadController videoDownloadController =
      Get.put(VideoDownloadController());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'G-shala',
            textScaleFactor: 1.2,
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GetBuilder<VideoControllerGetX>(
                init: VideoControllerGetX(),
                builder: (vcontrol) => vcontrol.chewieController != null &&
                        vcontrol.chewieController!.videoPlayerController.value
                            .isInitialized
                    ? Center(
                        child: Column(
                          children: [
                            Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.7,
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: Chewie(
                                    controller: vcontrol.chewieController!)),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: VideoProgressIndicator(
                                  vController.videoPlayerController,
                                  allowScrubbing: true),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.fast_rewind),
                                ),
                                Obx(() {
                                  return vController.isVideoPlaying.value
                                      ? IconButton(
                                          onPressed: () {
                                            vController.toggleVideoPlay();
                                          },
                                          icon: Icon(Icons.pause),
                                        )
                                      : IconButton(
                                          onPressed: () {
                                            vController.toggleVideoPlay();
                                          },
                                          icon: Icon(Icons.play_arrow),
                                        );
                                }),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.fast_forward),
                                ),
                              ],
                            ),
                            CElevatedButton(
                                buttonLabel: 'Download Video',
                                onPressed: () {
                                  videoDownloadController.downloadFile();
                                }),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Obx(() {
                                return videoDownloadController
                                        .isdownloading.value
                                    ? Text(videoDownloadController
                                        .progressString.value)
                                    : Container(
                                        height: 0,
                                        width: 0,
                                      );
                              }),
                            )
                          ],
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [CircularProgressIndicator()],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
