import 'package:get/get.dart';

import '../../application/services/local_store.dart';
import '../../core/routes/app_routes.dart';

class OnboardingController extends GetxController {
  OnboardingController(this.localStore);

  final LocalStore localStore;

  final RxInt pageIndex = 0.obs;

  void setPage(int index) {
    pageIndex.value = index;
  }

  Future<void> finish() async {
    await localStore.writeBool('onboarding_complete', true);
    Get.offAllNamed(AppRoutes.home);
  }
}
