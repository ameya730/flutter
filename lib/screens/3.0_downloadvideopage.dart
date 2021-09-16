import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gshala/controllers/3.0_videodownload_controller.dart';
import 'package:gshala/controllers/2.1_videolist_controller.dart';
import 'package:gshala/database/video_db.dart';
import 'package:gshala/templates/custombutton.dart';

class DownloadVideoPage extends StatelessWidget {
  final VideoDownloadController videoDownloadController =
      Get.put(VideoDownloadController());
  final dbHelper = DatabaseProvider.db;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          shadowColor: Colors.transparent,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Video Name',
                style: TextStyle(color: Colors.white),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: CElevatedButton(
                    buttonLabel: 'Download Video',
                    onPressed: () {
                      videoDownloadController.downloadFile();
                    }),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Obx(() {
                  return videoDownloadController.isdownloading.value
                      ? Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 8.0,
                                  right: 8.0,
                                ),
                                child: Container(
                                  color: Colors.white,
                                  height: 10,
                                  width: MediaQuery.of(context).size.width *
                                      videoDownloadController.progressPercentage
                                          .toDouble(),
                                ),
                              ),
                            ),
                            Text(
                              videoDownloadController.progressString.value,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )
                      : Container(
                          height: 0,
                          width: 0,
                        );
                }),
              ),
              Obx(() {
                return videoDownloadController.downloadComplete.value
                    ? AlertDialog(
                        title: Text('Video Download'),
                        content: Text('Your video has been downloaded'),
                        actions: [
                          CElevatedButton(
                              buttonLabel: 'Ok',
                              onPressed: () {
                                final VideoListController videoListController =
                                    Get.put(VideoListController());
                                videoListController.getVideosList();
                                videoDownloadController.downloadComplete.value =
                                    false;
                                videoDownloadController.isdownloading.value =
                                    false;
                                Get.offNamed('/offlinemainpage');
                              })
                        ],
                      )
                    : Container();
              }),
            ],
          ),
        ),
      ),
    );
  }
}
