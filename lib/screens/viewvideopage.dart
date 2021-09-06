import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gshala/controllers/videoview_controller.dart';
import 'package:gshala/database/video_db.dart';
import 'package:video_player/video_player.dart';

class ViewVideoPage extends StatelessWidget {
  final PlayVideoController vController = Get.put(PlayVideoController());
  final GetStorage box = GetStorage();
  final dbHelper = DatabaseProvider.db;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () {
          vController.videoUpdate();
          box.remove('i');
          Get.back();
          throw ('Action taken');
        },
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                vController.videoUpdate();
                box.remove('i');
                Get.back();
              },
              icon: Icon(Icons.arrow_back),
            ),
            centerTitle: true,
            title: Text(
              'Test',
              textScaleFactor: 1.2,
            ),
            backgroundColor: Theme.of(context).backgroundColor,
            shadowColor: Colors.transparent,
          ),
          backgroundColor: Theme.of(context).backgroundColor,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GetBuilder<PlayVideoController>(
                  init: PlayVideoController(),
                  builder: (vcontrol) => vcontrol.chewieController != null &&
                          vcontrol.chewieController!.videoPlayerController.value
                              .isInitialized
                      ? Center(
                          child: Column(
                            children: [
                              Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.7,
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: Chewie(
                                      controller: vcontrol.chewieController!)),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: VideoProgressIndicator(
                                    vController.videoPlayerController,
                                    allowScrubbing: true),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 8.0,
                                  bottom: 8.0,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: IconButton(
                                        onPressed: () {
                                          vController.rewindVideo();
                                        },
                                        icon: Icon(Icons.fast_rewind),
                                      ),
                                    ),
                                    Obx(() {
                                      return vController.isVideoPlaying.value
                                          ? CircleAvatar(
                                              backgroundColor: Colors.white,
                                              child: IconButton(
                                                onPressed: () {
                                                  vController.toggleVideoPlay();
                                                },
                                                icon: Icon(Icons.pause),
                                              ),
                                            )
                                          : CircleAvatar(
                                              backgroundColor: Colors.white,
                                              child: IconButton(
                                                onPressed: () {
                                                  vController.toggleVideoPlay();
                                                },
                                                icon: Icon(Icons.play_arrow),
                                              ),
                                            );
                                    }),
                                    CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: IconButton(
                                        onPressed: () {
                                          vController.forwardVideo();
                                        },
                                        icon: Icon(Icons.fast_forward),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
      ),
    );
  }
}
