import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gshala/controllers/videolist_controller.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gshala/database/video_db.dart';

class OfflineVideosList extends StatelessWidget {
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
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        childAspectRatio: 4,
                      ),
                      itemCount: videoListController.videoList.length,
                      itemBuilder: (context, i) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    box.write('i',
                                        videoListController.videoList[i].id);
                                    print(i);
                                    Get.toNamed('/viewvideopage');
                                  },
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    child: ListTile(
                                      title: Text(
                                        videoListController
                                            .videoList[i].videoName
                                            .toString(),
                                      ),
                                      subtitle: Text(
                                        videoListController
                                            .videoList[i].videoLastPosition
                                            .toString(),
                                      ),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.delete),
                                ),
                              ],
                            ),
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
