import 'package:get/get.dart';

import '../../application/services/local_store.dart';

class ProviderController extends GetxController {
  ProviderController(this.localStore);

  final LocalStore localStore;

  final RxList<Map<String, dynamic>> managedItems = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> managedCategories = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  void _load() {
    managedItems.assignAll(localStore.readList('provider_items').whereType<Map<String, dynamic>>());
    managedCategories.assignAll(localStore.readList('provider_categories').whereType<Map<String, dynamic>>());
  }

  Future<void> addItem(Map<String, dynamic> item) async {
    managedItems.add(item);
    await localStore.writeList('provider_items', managedItems.toList());
  }

  Future<void> removeItem(String id) async {
    managedItems.removeWhere((Map<String, dynamic> element) => element['id'] == id);
    await localStore.writeList('provider_items', managedItems.toList());
  }

  Future<void> addCategory(Map<String, dynamic> category) async {
    managedCategories.add(category);
    await localStore.writeList('provider_categories', managedCategories.toList());
  }
}
