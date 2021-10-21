import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class PermissionHandler extends GetxController {
  final box = GetStorage();
  final isPermissionGiven = false.obs;
  final alertBoxOpen = false.obs;
  checkDownloadPermission() {
    if (box.read('downloadPermission') == null) {
      isPermissionGiven.value = true;
      alertBoxOpen.value = true;
    }
  }
}
