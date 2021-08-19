import 'dart:io';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';

class VideoDownloadController extends GetxController {
  final videoName = 'BigBuckBunny.mp4'.obs;
  final isdownloading = false.obs;
  final progressString = ''.obs;
  Dio dio = Dio();

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> downloadFile() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    try {
      var dir = await getApplicationDocumentsDirectory();
      print("path ${dir.path}");
      String imgUrl =
          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4';
      isdownloading.value = true;
      await dio.download(imgUrl, "${appDir.path}/videos/bee.mp4",
          onReceiveProgress: (rec, total) {
        print("Rec: $rec , Total: $total");

        progressString.value = ((rec / total) * 100).toStringAsFixed(0) + "%";
      });
    } catch (e) {
      print(e);
    }
    print(appDir.listSync());
  }
}
