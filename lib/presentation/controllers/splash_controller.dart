import 'dart:async';

import 'package:get/get.dart';

import '../../core/routes/app_routes.dart';
import 'mixins/guarded_controller_mixin.dart';

class SplashController extends GetxController with GuardedControllerMixin {
  @override
  void onInit() {
    super.onInit();
    final timer = Timer(const Duration(seconds: 1), () {
      Get.offAllNamed(AppRoutes.home);
    });
    trackTimer(timer);
  }

  @override
  void onClose() {
    cancelTimers();
    super.onClose();
  }
}
