import 'dart:io';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gshala/const.dart';
import 'package:gshala/controllers/2.1_videolist_controller.dart';
import 'package:gshala/controllers/4.0_videoview_controller.dart';
import 'package:gshala/database/video_db.dart';

class PostLoginOfflineMainPage extends StatelessWidget {
  final VideoListController videoListController =
      Get.put(VideoListController());
  final GetStorage box = new GetStorage();
  final dbHelper = DatabaseProvider.db;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Welcome'.tr),
          backgroundColor: Theme.of(context).backgroundColor,
          shadowColor: Colors.transparent,
          actions: [
            IconButton(
              onPressed: () {
                Get.offAndToNamed('/downloadvideopage');
              },
              icon: Icon(Icons.download),
            ),
            IconButton(
              onPressed: () {
                Get.offAndToNamed('/profilepage');
              },
              icon: Icon(Icons.person),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.offAndToNamed('/webviewpage');
          },
          child: Icon(Icons.web_stories),
        ),
        body: Center(
          child: Column(
            children: [
              TopWidget(),
              Obx(() {
                return videoListController.listObtained.value
                    ? ListView.builder(
                        shrinkWrap: true,
                        itemCount: videoListController.videoList.length,
                        itemBuilder: (context, i) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                              ),
                              child: Column(
                                children: [
                                  GestureDetector(
                                    child: Image(
                                      image: FileImage(
                                        File(
                                          videoListController.thumbNailList[i],
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      box.write('i', i);
                                      print(box.read('i'));
                                      box.write(
                                          'videoName',
                                          videoListController
                                              .videoList[i].videoName);
                                      box.write(
                                          'videoLastPosition',
                                          videoListController.videoList[i]
                                              .videoLastViewPosition);
                                      PlayVideoController playVideoController =
                                          Get.put(PlayVideoController());
                                      playVideoController.initializePlayer();
                                      Get.toNamed('/viewvideopage');
                                    },
                                  ),
                                  ListTile(
                                    title: Text(
                                      videoListController.videoList[i].videoName
                                          .toString()
                                          .split('.')
                                          .first,
                                    ),
                                    trailing: IconButton(
                                        onPressed: () async {
                                          await dbHelper.updateDeleteVideoFlat(
                                              videoListController
                                                  .videoList[i].videoName
                                                  .toString());
                                          await videoListController
                                              .getVideosList();
                                        },
                                        icon: Icon(Icons.delete)),
                                  ),
                                ],
                              ),
                            ),
                          );
                        })
                    : Center(
                        child: Column(
                          children: [
                            Image(
                              image: AssetImage('assets/offlineimageone.gif'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                'No videos have been downloaded for offline viewing',
                                textAlign: TextAlign.center,
                                textScaleFactor: 1.5,
                                style: TextStyle(
                                  color: normalWhiteText,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class TopWidget extends StatelessWidget {
  const TopWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        border: Border(
          bottom: BorderSide(
            color: normalWhiteText,
            width: 2,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          top: 16.0,
          bottom: 8.0,
          right: 16.0,
          left: 4.0,
        ),
        child: Flex(
          direction: Axis.horizontal,
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('assets/offlineimage.gif'),
              radius: 47,
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  'OfflineMessage'.tr,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    color: normalWhiteText,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
