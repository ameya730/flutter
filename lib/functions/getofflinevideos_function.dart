import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gshala/controllers/2.1_videolist_controller.dart';
import 'package:gshala/controllers/2.5_offlinevideoview_controller.dart';
import 'package:gshala/screens/2.2_offlinemainpage.dart';

moveToOffline() async {
  final box = new GetStorage();
  final VideoListController videoListController =
      Get.put(VideoListController());
  final offlineVideosPageView = Get.put(OfflineVideosPageView());
  videoListController.listObtained.value = false;
  videoListController.subjectListObtained.value = false;
  if (box.read('userId') != null) {
    await videoListController.getVideosList();
  }
  offlineVideosPageView.isOfflineVideoPageOpen.value = true;
  Get.to(() => PostLoginOfflineMainPage());
}
