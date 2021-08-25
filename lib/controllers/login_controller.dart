import 'package:get/get.dart';

class LogInController extends GetxController {
  final userId = ''.obs;
  final password = ''.obs;
  final loginType = ''.obs;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'username': userId.value,
      'password': password.value,
      'loginType': loginType.value,
    };
    print(map);
    return map;
  }
}
