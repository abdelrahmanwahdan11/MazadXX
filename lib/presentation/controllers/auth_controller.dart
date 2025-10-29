import 'package:get/get.dart';

import '../../application/services/local_store.dart';
import '../../core/routes/app_routes.dart';

class AuthController extends GetxController {
  AuthController(this.localStore);

  final LocalStore localStore;

  final RxString email = ''.obs;
  final RxString password = ''.obs;
  final RxBool rememberMe = false.obs;

  void updateEmail(String value) => email.value = value;
  void updatePassword(String value) => password.value = value;

  Future<void> login() async {
    await localStore.writeJson('auth', <String, Object?>{
      'email': email.value,
      'remember': rememberMe.value,
    });
    Get.offAllNamed(AppRoutes.home);
  }

  Future<void> signup() async {
    await login();
  }
}
