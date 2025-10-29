import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../application/services/format_service.dart';
import '../controllers/settings_controller.dart';
import '../widgets/glass_card.dart';
import '../widgets/m3_segmented_button.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final SettingsController controller = Get.find<SettingsController>();
  final FormatService formatService = Get.find<FormatService>();
  final TextEditingController pinController = TextEditingController();

  @override
  void dispose() {
    pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('settings'.tr)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Obx(() {
              final themeMode = controller.themeController.themeMode;
              return GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('theme'.tr, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 12),
                    M3SegmentedButton<String>(
                      segments: {
                        'system': 'system'.tr,
                        'light': 'light'.tr,
                        'dark': 'dark'.tr,
                      },
                      selected: themeMode.name,
                      onChanged: (value) => controller.setThemeMode(_modeFromName(value)),
                    ),
                    const SizedBox(height: 16),
                    Text('text_scale'.tr),
                    Builder(
                      builder: (context) {
                        final currentScale = controller.themeController.textScaler.scale(16) / 16;
                        return Slider(
                          value: currentScale,
                          min: 0.8,
                          max: 1.4,
                          divisions: 6,
                          label: currentScale.toStringAsFixed(1),
                          onChanged: (value) => controller.setTextScale(value),
                        );
                      },
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 24),
            Obx(() {
              final locale = controller.localeController.currentLocale;
              return GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('language'.tr, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 12),
                    DropdownButton<Locale>(
                      value: locale,
                      onChanged: (value) {
                        if (value != null) {
                          controller.setLanguage(value);
                        }
                      },
                      items: const [
                        Locale('en', 'US'),
                        Locale('ar', 'AR'),
                      ]
                          .map(
                            (locale) => DropdownMenuItem<Locale>(
                              value: locale,
                              child: Text(locale.languageCode == 'ar' ? 'arabic'.tr : 'english'.tr),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 24),
            Obx(
              () => GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SwitchListTile(
                      title: Text('reduce_motion'.tr),
                      value: controller.reduceMotion.value,
                      onChanged: controller.toggleReduceMotion,
                    ),
                    SwitchListTile(
                      title: Text('high_contrast'.tr),
                      value: controller.highContrast.value,
                      onChanged: controller.toggleHighContrast,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('digits_units'.tr, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  Text('currency_example'.trParams({'value': formatService.currency(1280.5)})),
                  Text('vat_example'.trParams({'value': formatService.vatAmount(1280.5)})),
                  Text('units_example'.trParams({'value': formatService.formatUnits(3.5, 'weight')})),
                ],
              ),
            ),
            const SizedBox(height: 24),
            GlassCard(
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => controller.actionLog.add('settings_export'),
                      child: Text('export_json'.tr),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () => controller.actionLog.add('settings_import'),
                      child: Text('import_json'.tr),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('pin_code'.tr, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  TextField(
                    controller: pinController,
                    decoration: InputDecoration(labelText: 'enter_pin'.tr),
                    keyboardType: TextInputType.number,
                    obscureText: true,
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () async {
                      await controller.localStore.writeJson('secure_pin', <String, String>{'pin': pinController.text});
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('settings_saved'.tr)),
                        );
                      }
                    },
                    child: Text('save_pin'.tr),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('i18n_audit'.tr, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  Text('missing_translations'.trParams({'count': controller.missingKeys().length.toString()})),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ThemeMode _modeFromName(String name) {
    switch (name) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}
