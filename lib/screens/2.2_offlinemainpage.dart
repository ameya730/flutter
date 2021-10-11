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
import 'package:gshala/templates/custombutton.dart';
import 'package:gshala/templates/customdropdown.dart';

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
        onWillPop: () async {
          await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Exit App'.tr),
                  content: Text(
                    'HomePageGoBackContent'.tr,
                    textAlign: TextAlign.justify,
                  ),
                  actions: [
                    CElevatedButton(
                        buttonLabel: 'Yes'.tr,
                        onPressed: () {
                          exit(0);
                        }),
                    CElevatedButton(
                        buttonLabel: 'No'.tr,
                        onPressed: () {
                          // Future.value(false);
                          Navigator.pop(context, false);
                        }),
                  ],
                );
              });
          throw Exception('Issue');
        },
        child: Scaffold(
          floatingActionButton: SpeedDial(
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
                labelStyle:
                    TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
                labelBackgroundColor: Colors.black,
              ),
              SpeedDialChild(
                child: Icon(Icons.logout_rounded, color: Colors.white),
                backgroundColor: Theme.of(context).backgroundColor,
                onTap: () {
                  box.remove('userName');
                  box.remove('uType');
                  box.remove('userId');
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (BuildContext context) => HomePage(),
                    ),
                    (route) => false,
                  );
                },
                label: 'Log Out'.tr,
                labelStyle:
                    TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
                labelBackgroundColor: Colors.black,
              ),
            ],
          ),
          backgroundColor: Theme.of(context).backgroundColor,
          body: Center(
            child: CustomScrollView(
              scrollDirection: Axis.vertical,
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: true,
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          TopWidget(),
                          Obx(() {
                            return videoListController.listObtained.value
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                      top: 16.0,
                                      bottom: 8.0,
                                    ),
                                    child: CustomDropDownField(
                                      hinttext: 'Filter by Subject'.tr,
                                      dropDownValue: videoListController
                                                  .filteredSubject.value !=
                                              ''
                                          ? videoListController
                                              .filteredSubject.value
                                          : null,
                                      dropList:
                                          videoListController.subjectsList,
                                      onChanged: (value) async {
                                        videoListController.isFiltered.value =
                                            true;
                                        videoListController
                                            .filteredSubject.value = value;
                                        await videoListController
                                            .getVideosList();
                                      },
                                    ),
                                  )
                                : Container(
                                    height: 0,
                                    width: 0,
                                  );
                          }),
                          Obx(
                            () {
                              return videoListController.listObtained.value
                                  ? Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 16.0),
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount: videoListController
                                              .filteredVideoList.length,
                                          itemBuilder: (context, i) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                left: 16.0,
                                                right: 16.0,
                                                top: 8.0,
                                                bottom: 8.0,
                                              ),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(10),
                                                    bottomRight:
                                                        Radius.circular(10),
                                                    topLeft:
                                                        Radius.circular(10),
                                                    topRight:
                                                        Radius.circular(10),
                                                  ),
                                                ),
                                                child: Column(
                                                  children: [
                                                    ListTile(
                                                      leading: GestureDetector(
                                                        onTap: () {
                                                          goToViewVideoPage(i);
                                                        },
                                                        child: CircleAvatar(
                                                          backgroundImage:
                                                              FileImage(
                                                            File(
                                                              videoListController
                                                                  .thumbNailList[i],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      title: GestureDetector(
                                                        onTap: () {
                                                          goToViewVideoPage(i);
                                                        },
                                                        child: Text(
                                                          videoListController
                                                              .filteredVideoList[
                                                                  i]
                                                              .topic
                                                              .toString(),
                                                        ),
                                                      ),
                                                      subtitle: GestureDetector(
                                                        onTap: () {
                                                          goToViewVideoPage(i);
                                                        },
                                                        child: Text(
                                                            videoListController
                                                                .filteredVideoList[
                                                                    i]
                                                                .subjectName
                                                                .toString()),
                                                      ),
                                                      trailing: IconButton(
                                                        onPressed: () async {
                                                          videoListController
                                                              .deletingVideo
                                                              .value = true;
                                                          String
                                                              videoNameToDelete =
                                                              videoListController
                                                                  .filteredVideoList[
                                                                      i]
                                                                  .videoName
                                                                  .toString()
                                                                  .split('.')
                                                                  .first;
                                                          await videoListController
                                                              .deleteVideoFromFile(
                                                                  videoNameToDelete);
                                                          await videoListController
                                                              .deleteThumbNailFromFile(
                                                                  videoNameToDelete);
                                                          await dbHelper
                                                              .updateDeleteVideoFlat(
                                                            videoListController
                                                                .filteredVideoList[
                                                                    i]
                                                                .videoName
                                                                .toString(),
                                                          );
                                                          videoListController
                                                              .subjectListObtained
                                                              .value = false;
                                                          videoListController
                                                              .listObtained
                                                              .value = false;
                                                          await videoListController
                                                              .getVideosList();
                                                          videoListController
                                                              .deletingVideo
                                                              .value = false;
                                                        },
                                                        icon:
                                                            Icon(Icons.delete),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }),
                                    )
                                  : Center(
                                      child: Column(
                                        children: [
                                          Image(
                                            image: AssetImage(
                                                'assets/offlineimageone.gif'),
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
                            },
                          ),
                        ],
                      ),
                      Obx(
                        () {
                          return videoListController.deletingVideo.value
                              ? Container(
                                  height: MediaQuery.of(context).size.height,
                                  width: MediaQuery.of(context).size.width,
                                  color: Colors.black87,
                                  child: Text(
                                    'Deleting Video'.tr,
                                    style: TextStyle(color: normalWhiteText),
                                  ),
                                )
                              : Container(
                                  height: 0,
                                  width: 0,
                                );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  goToViewVideoPage(int i) {
    box.write('i', i);
    print(box.read('i'));
    box.write('videoName', videoListController.videoList[i].videoName);
    box.write('videoLastPosition',
        videoListController.videoList[i].videoLastViewPosition);
    PlayVideoController playVideoController = Get.put(PlayVideoController());
    playVideoController.initializePlayer();
    Get.toNamed('/viewvideopage');
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
