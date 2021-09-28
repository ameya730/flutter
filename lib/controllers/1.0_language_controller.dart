import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gshala/localization_service.dart';

class LanguageController extends GetxController {
  var selectedLanguage = 'ગુજરાતી'.obs;
  final webViewLanguage = ''.obs;
  late Locale locale;

  @override
  void onInit() {
    changeLangauge();
    super.onInit();
  }

  changeLanguageWebView() {
    if (webViewLanguage.value != '') {
      if (webViewLanguage.value == 'gj') {
        locale = Locale('gu', 'IN');
      } else if (webViewLanguage.value == 'en') {
        locale = Locale('en', 'US');
      }
      LocalizationService().keys;
      Get.updateLocale(locale);
      update();
    }
  }

  void changeLangauge() {
    if (selectedLanguage.value == 'English') {
      locale = Locale('en', 'US');
    } else if (selectedLanguage.value == 'ગુજરાતી') {
      locale = Locale('gu', 'IN');
    }
    LocalizationService().keys;
    Get.updateLocale(locale);
    update();
  }
}
