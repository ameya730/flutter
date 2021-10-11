import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gshala/const.dart';
import 'package:gshala/controllers/2.1_videolist_controller.dart';
import 'package:gshala/controllers/5.0_profile_selection_controller.dart';
import 'package:gshala/database/video_db.dart';
import 'package:gshala/screens/1_homepage.dart';
import 'package:gshala/screens/2.2_offlinemainpage.dart';
import 'package:gshala/templates/profilecards.dart';

class OfflineProfileSelectionPage extends StatelessWidget {
  final profileControl = Get.put(ProfileSelectioController());
  final box = new GetStorage();
  final dbHelper = DatabaseProvider.db;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: normalWhiteText,
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: backGroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          onPressed: () {
            logOut(context);
          },
          label: Text(
            'Log Out'.tr,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Obx(() {
          return profileControl.profileListObtained.value
              ? Container(
                  decoration: BoxDecoration(
                    color: backGroundColor,
                    gradient: LinearGradient(
                      colors: [
                        backGroundColor.withOpacity(0.9),
                        normalWhiteText.withOpacity(0.15),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Text(
                          'Choose a profile'.tr,
                          style: TextStyle(
                            color: normalWhiteText,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: profileControl.listOfProfiles.length,
                          itemBuilder: (BuildContext context, int i) {
                            return ProfileCard(
                              cardNo: i + 1,
                              personName:
                                  profileControl.listOfProfiles[i].firstName,
                              personRollNo:
                                  profileControl.listOfProfiles[i].userName,
                              classNo:
                                  profileControl.listOfProfiles[i].batchname,
                              onTap: () {
                                box.write('userId',
                                    profileControl.listOfProfiles[i].userId);
                                moveToOffline();
                              },
                            );
                          }),
                    ],
                  ),
                )
              : Center(
                  child: CircularProgressIndicator.adaptive(),
                );
        }),
      ),
    );
  }

  moveToOffline() async {
    final VideoListController videoListController =
        Get.put(VideoListController());
    videoListController.listObtained.value = false;
    videoListController.subjectListObtained.value = false;
    if (box.read('userId') != null) {
      await videoListController.getVideosList();
    }
    Get.to(() => PostLoginOfflineMainPage());
  }

  logOut(BuildContext context) async {
    await dbHelper.deleteProfiles();
    box.remove('userName');
    box.remove('uType');
    box.remove('userId');
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (BuildContext context) => HomePage(),
      ),
      (route) => false,
    );
  }
}
