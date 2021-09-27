import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gshala/controllers/1.1_login_controller.dart';

class AccessTokenController extends GetxController {
  final isTokenActive = false.obs;
  final box = new GetStorage();
  final LogInController logInController = Get.put(LogInController());

  getToken() async {
    if (box.read('accessTokenTimeStamp') != null) {
      DateTime tokenStartTime = DateTime.parse(
        box.read('accessTokenTimeStamp'),
      );
      int tokenActiveDuration =
          DateTime.now().difference(tokenStartTime).inSeconds;
      if (tokenActiveDuration > 160) {
        await logInController.login();
      }
    }
  }
}
