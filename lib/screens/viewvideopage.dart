import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gshala/controllers/videocontroller.dart';

class ViewVideoPage extends StatelessWidget {
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GetBuilder<VideoControllerGetX>(
                init: VideoControllerGetX(),
                builder: (vcontrol) => Expanded(
                  child: vcontrol.chewieController != null &&
                          vcontrol.chewieController!.videoPlayerController.value
                              .isInitialized
                      ? Chewie(controller: vcontrol.chewieController!)
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [CircularProgressIndicator()],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
