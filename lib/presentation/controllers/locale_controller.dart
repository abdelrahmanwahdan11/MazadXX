import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocaleController extends GetxController {
  final Rx<Locale> _locale = const Locale('en', 'US').obs;

  Locale get currentLocale => _locale.value;
  bool get isRtl => _locale.value.languageCode == 'ar';

  void setLocale(Locale locale) {
    _locale.value = locale;
    Get.updateLocale(locale);
  }
}
