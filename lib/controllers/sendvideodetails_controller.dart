import 'package:get/get.dart';

class SendVideoDetailsController extends GetxController {
  final videoDuration = ''.obs;
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'videoDuration': videoDuration.value,
    };
    print(map);
    return map;
  }
}
