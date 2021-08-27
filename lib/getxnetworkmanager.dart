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

      if (box.read('userName') != null) {
        isLoggedIn.value = true;
      } else if (box.read('userName') == null) {
        isLoggedIn.value = false;
      }

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

  // checkLogInStatus() {
  //   if (box.read('userName') != null) {
  //     isLoggedIn.value = true;
  //   } else if (box.read('userName') == null) {
  //     isLoggedIn.value = false;
  //   }
  //   showPage();
  // }

  // showPage() {
  //   if (connectionType.value == 0 && isLoggedIn.value == false) {
  //     page.value = 0;
  //   } else if (connectionType.value == 1 && isLoggedIn.value == false) {
  //     page.value = 1;
  //   } else if (connectionType.value == 0 && isLoggedIn.value == true) {
  //     page.value = 2;
  //   } else if (connectionType.value == 1 && isLoggedIn.value == true) {
  //     page.value = 3;
  //   }
  //   print('The page to be displayed is :$page.value');
  //   validationDone.value = true;
  //   update();
  //   return page.value;
  // }
}
