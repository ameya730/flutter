import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gshala/controllers/videolistcontroller.dart';
import 'package:get_storage/get_storage.dart';

class OfflineVideosList extends StatelessWidget {
  final VideoListController videoListController =
      Get.put(VideoListController());
  final GetStorage box = new GetStorage();

  @override
  Widget build(BuildContext context) {
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
                              box.write('i', i);
                              box.write(
                                  'videoName',
                                  videoListController.videoList[i].path
                                      .toString()
                                      .split('/')
                                      .last);
                              Get.toNamed('/viewvideopage');
                            },
                          ),
                        );
                      })
                  : Container(
                      child: Text(
                        'No videos downloaded...',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
            }),
          ),
        ),
      ),
    );
  }
}
