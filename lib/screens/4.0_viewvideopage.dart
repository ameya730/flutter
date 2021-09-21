import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gshala/const.dart';
import 'package:gshala/controllers/2.1_videolist_controller.dart';
import 'package:gshala/controllers/4.0_videoview_controller.dart';
import 'package:gshala/database/video_db.dart';

class ViewVideoPage extends StatefulWidget {
  Future<void> secureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  @override
  _ViewVideoPageState createState() => _ViewVideoPageState();
}

class _ViewVideoPageState extends State<ViewVideoPage> {
  @override
  void dispose() async {
    super.dispose();
    await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
  }

  final PlayVideoController vController = Get.put(PlayVideoController());
  final VideoListController videoListController =
      Get.put(VideoListController());

  final GetStorage box = GetStorage();

  final dbHelper = DatabaseProvider.db;

  @override
  Widget build(BuildContext context) {
    int i = box.read('i');
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
              videoListController.videoList[i].topic.toString(),
              textScaleFactor: 1.2,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: Theme.of(context).backgroundColor,
            shadowColor: Colors.transparent,
          ),
          backgroundColor: normalDarkText,
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.5,
                                width: MediaQuery.of(context).size.width,
                                child: Chewie(
                                    controller: vcontrol.chewieController!),
                              ),
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.35,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  children: [
                                    Card(
                                      child: ListTile(
                                        title: Text(
                                          'Video'.tr,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        subtitle: Text(
                                          videoListController.videoList[i].topic
                                              .toString(),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          child: Card(
                                            child: ListTile(
                                              title: Text(
                                                'Subject'.tr,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              subtitle: Text(
                                                videoListController
                                                    .videoList[i].subjectName
                                                    .toString(),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          child: Card(
                                            child: ListTile(
                                              title: Text(
                                                'Class'.tr,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              subtitle: Text(
                                                videoListController
                                                    .videoList[i].videoClass
                                                    .toString(),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
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
