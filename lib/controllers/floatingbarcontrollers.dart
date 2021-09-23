import 'package:get/get.dart';

class FloatingBarControllers extends GetxController {
  final signUpFloatBar = false.obs;

  @override
  void onInit() {
    super.onInit();
    signUpFloatBar.listen((value) {
      update();
    });
  }
}
