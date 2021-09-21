import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gshala/lang/en_us.dart';
import 'package:gshala/lang/gu_in.dart';

class LocalizationService extends Translations {
  static final locale = Locale('gu', 'IN');
  static final fallbackLocale = Locale('en', 'US');

  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': enUs,
        'gu_IN': guIn,
      };
}
