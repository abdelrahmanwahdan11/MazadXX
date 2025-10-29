import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../application/services/action_log.dart';
import '../../application/services/i18n_audit_service.dart';
import '../../application/services/local_store.dart';
import 'locale_controller.dart';
import 'theme_controller.dart';

class SettingsController extends GetxController {
  SettingsController({
    required this.themeController,
    required this.localeController,
    required this.localStore,
    required this.actionLog,
    required this.auditService,
  });

  final ThemeController themeController;
  final LocaleController localeController;
  final LocalStore localStore;
  final ActionLog actionLog;
  final I18nAuditService auditService;

  final RxBool reduceMotion = false.obs;
  final RxBool highContrast = false.obs;

  @override
  void onInit() {
    super.onInit();
    final prefs = localStore.readJson('settings');
    if (prefs != null) {
      reduceMotion.value = prefs['reduceMotion'] as bool? ?? false;
      highContrast.value = prefs['highContrast'] as bool? ?? false;
      final themeName = prefs['themeMode'] as String?;
      if (themeName != null) {
        final mode = ThemeMode.values.firstWhere(
          (ThemeMode element) => element.name == themeName,
          orElse: () => ThemeMode.system,
        );
        themeController.setThemeMode(mode);
      }
      final localeTag = prefs['locale'] as String?;
      if (localeTag != null) {
        final parts = localeTag.split('-');
        if (parts.isNotEmpty) {
          final locale = Locale(parts[0], parts.length > 1 ? parts[1] : null);
          localeController.setLocale(locale);
        }
      }
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    themeController.setThemeMode(mode);
    await _persist();
  }

  Future<void> setLanguage(Locale locale) async {
    localeController.setLocale(locale);
    await _persist();
  }

  Future<void> setTextScale(double scale) async {
    themeController.setTextScale(scale);
    await _persist();
  }

  Future<void> toggleReduceMotion(bool value) async {
    reduceMotion.value = value;
    await _persist();
  }

  Future<void> toggleHighContrast(bool value) async {
    highContrast.value = value;
    themeController.setHighContrast(value);
    await _persist();
  }

  List<String> missingKeys() => auditService.missingKeys;

  Future<void> _persist() async {
    await localStore.writeJson('settings', <String, Object?>{
      'reduceMotion': reduceMotion.value,
      'highContrast': highContrast.value,
      'themeMode': themeController.themeMode.name,
      'locale': localeController.currentLocale.toLanguageTag(),
    });
    actionLog.add('settings_update');
  }
}
