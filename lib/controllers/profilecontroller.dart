import 'package:get/get.dart';

class ProfileController extends GetxController {
  final isProfileSelected = false.obs;
  final profileName = ''.obs;

  profileSelection() {
    if (isProfileSelected.value == false) {
      isProfileSelected.value = true;
    } else if (isProfileSelected.value == true) {
      isProfileSelected.value = false;
    }
  }
}
