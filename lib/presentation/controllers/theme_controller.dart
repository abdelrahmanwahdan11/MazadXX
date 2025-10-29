import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  final Rx<ThemeMode> _themeMode = ThemeMode.system.obs;
  final RxDouble _textScaleFactor = 1.0.obs;
  final RxBool _highContrast = false.obs;

  ThemeMode get themeMode => _themeMode.value;
  TextScaler get textScaler => TextScaler.linear(_textScaleFactor.value);
  bool get highContrast => _highContrast.value;

  void setThemeMode(ThemeMode mode) {
    _themeMode.value = mode;
  }

  void setTextScale(double scale) {
    _textScaleFactor.value = scale;
  }

  void setHighContrast(bool value) {
    _highContrast.value = value;
  }
}
