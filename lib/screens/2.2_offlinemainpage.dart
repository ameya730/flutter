import 'dart:io';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gshala/const.dart';
import 'package:gshala/controllers/1.0_language_controller.dart';
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
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          floatingActionButton: FabCircularMenu(children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: TextButton.icon(
                onPressed: () {
                  Get.offAndToNamed('/webviewpage');
                },
                icon: Icon(
                  Icons.web_asset,
                  color: normalWhiteText,
                ),
                label: Text(
                  'Go Online'.tr,
                  style: TextStyle(
                    color: normalWhiteText,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: TextButton.icon(
                onPressed: () {
                  SchedulerBinding.instance!.addPostFrameCallback((_) async {
                    box.remove('userName');
                    await Navigator.popAndPushNamed(
                      context,
                      '/homepage',
                    );
                  });
                },
                icon: Icon(
                  Icons.logout,
                  color: normalWhiteText,
                ),
                label: Text(
                  'Log Out'.tr,
                  style: TextStyle(
                    color: normalWhiteText,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: TextButton.icon(
                onPressed: () async {
                  LanguageController lControl = Get.put(LanguageController());
                  if (lControl.selectedLanguage.value == 'English') {
                    lControl.selectedLanguage.value = 'ગુજરાતી';
                  } else if (lControl.selectedLanguage.value == 'ગુજરાતી') {
                    lControl.selectedLanguage.value = 'English';
                  }
                  lControl.changeLangauge();
                },
                icon: Icon(
                  Icons.language_sharp,
                  color: normalWhiteText,
                ),
                label: Text(
                  'Language'.tr,
                  style: TextStyle(
                    color: normalWhiteText,
                  ),
                ),
              ),
            ),
          ]),

          // FloatingActionButton(
          //   onPressed: () {
          //     Get.offAndToNamed('/webviewpage');
          //   },
          //   child: Icon(Icons.web_stories),
          // ),
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
                                            videoListController
                                                .thumbNailList[i],
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
                                        PlayVideoController
                                            playVideoController =
                                            Get.put(PlayVideoController());
                                        playVideoController.initializePlayer();
                                        Get.toNamed('/viewvideopage');
                                      },
                                    ),
                                    ListTile(
                                      title: Text(
                                        videoListController.videoList[i].topic
                                            .toString(),
                                      ),
                                      subtitle: Text(videoListController
                                          .videoList[i].subjectName
                                          .toString()),
                                      trailing: IconButton(
                                          onPressed: () async {
                                            await dbHelper
                                                .updateDeleteVideoFlat(
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
