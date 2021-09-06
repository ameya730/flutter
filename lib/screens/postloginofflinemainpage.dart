import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gshala/controllers/videolist_controller.dart';
import 'package:gshala/templates/custombutton.dart';

class PostLoginOfflineMainPage extends StatelessWidget {
  final GetStorage box = new GetStorage();
  @override
  Widget build(BuildContext context) {
    String profileName = box.read('profileName');
    print(profileName);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Welcome $profileName'),
          backgroundColor: Theme.of(context).backgroundColor,
          shadowColor: Colors.transparent,
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset(
                  'assets/offlineimage.gif',
                  height: 300,
                  width: 300,
                ),
                Container(
                  width: 300,
                  child: Text(
                    'You are offline. \nPlease click the below button to see the list of all videos that you have downloaded',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
                CElevatedButton(
                    buttonLabel: 'Download Video',
                    onPressed: () {
                      Get.toNamed('/downloadvideopage');
                    }),
                CElevatedButton(
                    buttonLabel: 'Offline Videos',
                    onPressed: () {
                      final VideoListController videoListController =
                          Get.put(VideoListController());
                      videoListController.getVideosList();
                      Get.toNamed('/offlinevideoslist');
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
