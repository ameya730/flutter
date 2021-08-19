import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gshala/controllers/videocontroller.dart';
import 'package:gshala/controllers/videolistcontroller.dart';
import 'package:video_player/video_player.dart';

class OfflineVideosList extends StatelessWidget {
  final VideoControllerGetX vController = Get.put(VideoControllerGetX());
  final VideoListController videoListController =
      Get.put(VideoListController());
  @override
  Widget build(BuildContext context) {
    late VideoPlayerController videoPlayerController;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Downloaded Videos',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Theme.of(context).backgroundColor,
          shadowColor: Colors.transparent,
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        body: Center(
          child: Align(
            alignment: Alignment.topCenter,
            child: Obx(() {
              return videoListController.listObtained.value
                  ? GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1),
                      itemCount: videoListController.videoList.length,
                      itemBuilder: (context, i) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            child: Card(
                              child: ListTile(
                                title: Text(
                                  videoListController.videoList[i].path
                                      .split('/')
                                      .last,
                                ),
                              ),
                            ),
                            onTap: () {
                              Get.toNamed('/viewvideopage');
                            },
                          ),
                        );
                      })
                  : CircularProgressIndicator();
            }),
          ),
        ),
      ),
    );
  }
}
