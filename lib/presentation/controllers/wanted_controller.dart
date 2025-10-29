import 'package:get/get.dart';

import '../../application/services/action_log.dart';
import '../../application/services/index_service.dart';
import '../../data/models/wanted_item.dart';
import '../../data/repositories/wanted_repository.dart';

class WantedController extends GetxController {
  WantedController({
    required this.wantedRepository,
    required this.indexService,
    required this.actionLog,
  });

  final WantedRepository wantedRepository;
  final IndexService indexService;
  final ActionLog actionLog;

  final RxList<WantedItem> _items = <WantedItem>[].obs;
  final RxList<WantedItem> visibleItems = <WantedItem>[].obs;
  final RxString searchTerm = ''.obs;
  final RxBool isLoading = false.obs;
  final RxBool showGrid = false.obs;
  final RxSet<String> saved = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    final data = await wantedRepository.fetchWanted();
    _items.assignAll(data);
    _applySearch();
    isLoading.value = false;
  }

  void search(String value) {
    searchTerm.value = value;
    _applySearch();
  }

  void toggleLayout() {
    showGrid.toggle();
  }

  void toggleSaved(String id) {
    if (saved.contains(id)) {
      saved.remove(id);
      actionLog.add('Removed $id from saved wanted');
    } else {
      saved.add(id);
      actionLog.add('Saved $id');
    }
  }
  void _applySearch() {
    final ids = indexService.searchWanted(_items, searchTerm.value);
    final mapped = <WantedItem>[];
    for (final id in ids) {
      final match = _findById(id);
      if (match != null) mapped.add(match);
    }
    visibleItems.assignAll(mapped);
  }

  WantedItem? _findById(String id) {
    for (final item in _items) {
      if (item.id == id) return item;
    }
    return null;
  }
}
