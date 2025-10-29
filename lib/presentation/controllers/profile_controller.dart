import 'package:get/get.dart';

import '../../application/services/local_store.dart';
import '../../domain/entities/entities.dart';
import '../../domain/usecases/usecases.dart';

class ProfileController extends GetxController {
  ProfileController({required this.getUserByIdUseCase, required this.localStore});

  final GetUserByIdUseCase getUserByIdUseCase;
  final LocalStore localStore;

  final Rx<User?> user = Rx<User?>(null);
  final RxString userId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _init();
  }

  Future<void> _init() async {
    final stored = localStore.readJson('current_user')?['id'] as String?;
    userId.value = stored ?? 'u_01';
    await load();
  }

  Future<void> load() async {
    user.value = await getUserByIdUseCase(userId.value);
  }

  Future<void> switchUser(String id) async {
    userId.value = id;
    await localStore.writeJson('current_user', <String, String>{'id': id});
    await load();
  }
}
