import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class CheckInternetConnection extends GetxController {
  final isInternetPresent = true.obs;
  late ConnectivityResult connectivityResult = ConnectivityResult.none;

  int connectionType = 0;
  final Connectivity _connectivity = Connectivity();

  @override
  void onInit() {
    super.onInit();
    checkInternetConnection();
  }

  Future<void> checkInternetConnection() async {
    try {
      connectivityResult = await (_connectivity.checkConnectivity());
    } catch (e) {}
    return _updateState(connectivityResult);
  }

  _updateState(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
        connectionType = 1;
        update();
        break;
      case ConnectivityResult.mobile:
        connectionType = 2;
        update();
        break;
      case ConnectivityResult.none:
        connectionType = 0;
        update();
        break;
      default:
        Get.snackbar('Network Error', 'Failed to get Network Status');
        break;
    }
  }
}
