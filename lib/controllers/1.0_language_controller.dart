import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gshala/localization_service.dart';

class LanguageController extends GetxController {
  var selectedLanguage = 'ગુજરાતી'.obs;
  late Locale locale;

  @override
  void onInit() {
    changeLangauge();
    super.onInit();
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
