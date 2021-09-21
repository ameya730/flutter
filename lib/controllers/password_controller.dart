import 'package:get/get.dart';

class PasswordController extends GetxController {
  final showPassword = false.obs;

  togglePassword() {
    if (showPassword.value == false) {
      showPassword.value = true;
    } else if (showPassword.value == true) {
      showPassword.value = false;
    }
    update();
  }
}
