import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gshala/const.dart';
import 'package:gshala/controllers/2.1_videolist_controller.dart';
import 'package:gshala/controllers/4.0_videoview_controller.dart';
import 'package:gshala/database/video_db.dart';
import 'package:gshala/getxnetworkmanager.dart';
import 'package:gshala/screens/1_homepage.dart';

class PostLoginOfflineMainPage extends StatelessWidget {
  final VideoListController videoListController =
      Get.put(VideoListController());
  final GetStorage box = new GetStorage();
  final dbHelper = DatabaseProvider.db;
  final GetXNetworkManager getXNetworkManager = Get.put(GetXNetworkManager());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          floatingActionButton: Obx(() {
            return getXNetworkManager.connectionPresent.value
                ? SpeedDial(
                    icon: Icons.menu,
                    activeIcon: Icons.close,
                    backgroundColor: Theme.of(context).backgroundColor,
                    visible: true,
                    curve: Curves.bounceInOut,
                    spaceBetweenChildren: 10,
                    spacing: 10,
                    children: [
                      SpeedDialChild(
                        child: Icon(Icons.keyboard_return, color: Colors.white),
                        backgroundColor: Theme.of(context).backgroundColor,
                        onTap: () {
                          Navigator.pop(context);
                        },
                        label: 'Return'.tr,
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.w500, color: Colors.white),
                        labelBackgroundColor: Colors.black,
                      ),
                      SpeedDialChild(
                        child: Icon(Icons.logout_rounded, color: Colors.white),
                        backgroundColor: Theme.of(context).backgroundColor,
                        onTap: () {
                          box.remove('userName');
                          box.remove('uType');
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (BuildContext context) => HomePage(),
                            ),
                            (route) => false,
                          );
                        },
                        label: 'Log Out'.tr,
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.w500, color: Colors.white),
                        labelBackgroundColor: Colors.black,
                      ),
                    ],
                  )
                : SpeedDial(
                    icon: Icons.menu,
                    activeIcon: Icons.close,
                    backgroundColor: Colors.green[900],
                    visible: true,
                    curve: Curves.bounceInOut,
                    spaceBetweenChildren: 10,
                    spacing: 10,
                    children: [
                      SpeedDialChild(
                        child: Icon(Icons.logout_rounded, color: Colors.white),
                        backgroundColor: Theme.of(context).backgroundColor,
                        onTap: () {
                          box.remove('userName');
                          box.remove('uType');
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (BuildContext context) => HomePage(),
                            ),
                            (route) => false,
                          );
                        },
                        label: 'Log Out'.tr,
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.w500, color: Colors.white),
                        labelBackgroundColor: Colors.black,
                      ),
                    ],
                  );
          }),
          backgroundColor: Theme.of(context).backgroundColor,
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TopWidget(),
                  Obx(() {
                    return videoListController.listObtained.value
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
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
                                          playVideoController
                                              .initializePlayer();
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
                                                          .videoList[i]
                                                          .videoName
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
                                  image:
                                      AssetImage('assets/offlineimageone.gif'),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    'No videos have been downloaded for offline viewing'
                                        .tr,
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
      ),
    );
  }
}

class TopWidget extends StatelessWidget {
  final GetXNetworkManager networkManager = Get.put(GetXNetworkManager());
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
                  networkManager.connectionPresent.value
                      ? 'OnlineOfflineMessage'.tr
                      : 'ActualOfflineMessage'.tr,
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
