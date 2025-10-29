import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'core/error/app_error_boundary.dart';
import 'core/localization/app_translations.dart';
import 'core/routes/app_pages.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'presentation/bindings/initial_binding.dart';
import 'presentation/controllers/locale_controller.dart';
import 'presentation/controllers/theme_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  InitialBinding().dependencies();
  runApp(const MazadxxApp());
}

class MazadxxApp extends StatelessWidget {
  const MazadxxApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final localeController = Get.find<LocaleController>();

    return AppErrorBoundary(
      child: Obx(
        () => GetMaterialApp(
          title: 'mazadxx',
          defaultTransition: Transition.rightToLeftWithFade,
          translations: AppTranslations(),
          locale: localeController.currentLocale,
          fallbackLocale: const Locale('en', 'US'),
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: themeController.themeMode,
          initialRoute: AppRoutes.splash,
          getPages: AppPages.pages,
          debugShowCheckedModeBanner: false,
          builder: (context, child) {
            final media = MediaQuery.of(context);
            final textScaler = themeController.textScaler;
            return Directionality(
              textDirection: localeController.isRtl ? TextDirection.rtl : TextDirection.ltr,
              child: MediaQuery(
                data: media.copyWith(textScaler: textScaler),
                child: child ?? const SizedBox.shrink(),
              ),
            );
          },
        ),
      ),
    );
  }
}
