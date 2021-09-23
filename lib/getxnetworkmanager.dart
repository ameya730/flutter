import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class GetXNetworkManager extends GetxController {
  final validationDone = false.obs;
  final connectionType = 0.obs;
  final isLoggedIn = false.obs;
  final page = 0.obs;
  final Connectivity _connectivity = Connectivity();
  GetStorage box = new GetStorage();
  var internetStatus;
  final connectionPresent = false.obs;

  @override
  void onInit() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      print('The internet connection is : $result');
      if (result == ConnectivityResult.none) {
        connectionPresent.value = false;
        if (box.read('userName') == null) {
          showOfflinePage();
        } else if (box.read('userName') != null) {
          showPostLoginOfflinePage();
        }
      } else if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        connectionPresent.value = true;
        if (box.read('userName') == null) {
          showHomePage();
        } else if (box.read('userName') != null) {
          showWebViewPage();
        }
      }
    });
    super.onInit();
  }

  showOfflinePage() async {
    print('success');
    await Get.offAndToNamed('/nologinofflinescreen');
  }

  showPostLoginOfflinePage() async {
    await Get.offAndToNamed('/offlinemainpage');
  }

  showHomePage() async {
    await Get.offAndToNamed('/homepage');
  }

  showWebViewPage() async {
    await Get.offAndToNamed('/webviewpage');
  }

  getConnectionType() async {
    try {
      ConnectivityResult connectivityResult =
          await _connectivity.checkConnectivity();
      print(connectivityResult);
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi ||
          connectivityResult == ConnectivityResult.ethernet) {
        connectionType.value = 1;
      } else {
        connectionType.value = 0;
      }
      print(box.read('userName'));
      if (box.read('userName') != null) {
        isLoggedIn.value = true;
      } else if (box.read('userName') == null) {
        isLoggedIn.value = false;
      }

      print('Is user logged in : $isLoggedIn.value');

      if (connectionType.value == 0 && isLoggedIn.value == false) {
        page.value = 0;
      } else if (connectionType.value == 1 && isLoggedIn.value == false) {
        page.value = 1;
      } else if (connectionType.value == 0 && isLoggedIn.value == true) {
        page.value = 2;
      } else if (connectionType.value == 1 && isLoggedIn.value == true) {
        page.value = 3;
      }
      return page.value;

      // checkLogInStatus();
    } on PlatformException catch (e) {
      print(e);
    }
  }
}
