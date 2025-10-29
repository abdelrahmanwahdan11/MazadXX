import 'package:get/get.dart';

import '../../application/services/local_store.dart';
import '../../domain/entities/entities.dart';

class FiltersController extends GetxController {
  FiltersController({required this.localStore});

  final LocalStore localStore;

  final RxDouble minPrice = 0.0.obs;
  final RxDouble maxPrice = 10000.0.obs;
  final RxList<String> categories = <String>[].obs;
  final RxString location = ''.obs;
  final RxString condition = ''.obs;
  final RxList<SavedFilter> savedFilters = <SavedFilter>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadSaved();
  }

  Map<String, dynamic> buildFilter() => <String, dynamic>{
        'priceMin': minPrice.value,
        'priceMax': maxPrice.value,
        'category': categories.toList(),
        'location': location.value,
        'condition': condition.value,
      };

  Future<void> saveCurrent(String label) async {
    final filter = SavedFilter(
      id: 'filter_${DateTime.now().millisecondsSinceEpoch}',
      scope: 'global',
      payload: buildFilter(),
      label: label,
    );
    savedFilters.add(filter);
    await _persist();
  }

  Future<void> deleteFilter(String id) async {
    savedFilters.removeWhere((SavedFilter element) => element.id == id);
    await _persist();
  }

  void applySaved(SavedFilter filter) {
    final payload = filter.payload;
    minPrice.value = (payload['priceMin'] as num?)?.toDouble() ?? 0;
    maxPrice.value = (payload['priceMax'] as num?)?.toDouble() ?? 10000;
    categories.assignAll(List<String>.from(payload['category'] as List? ?? <String>[]));
    location.value = payload['location'] as String? ?? '';
    condition.value = payload['condition'] as String? ?? '';
  }

  Future<void> _persist() async {
    await localStore.writeList(
      'saved_filters',
      savedFilters
          .map((SavedFilter e) => <String, dynamic>{
                'id': e.id,
                'scope': e.scope,
                'payload': e.payload,
                'label': e.label,
              })
          .toList(),
    );
  }

  void _loadSaved() {
    final data = localStore.readList('saved_filters');
    savedFilters.assignAll(
      data
          .whereType<Map<String, dynamic>>()
          .map(
            (Map<String, dynamic> e) => SavedFilter(
              id: e['id'] as String,
              scope: e['scope'] as String,
              payload: (e['payload'] as Map<String, dynamic>?) ?? <String, dynamic>{},
              label: e['label'] as String? ?? '',
            ),
          )
          .toList(),
    );
  }
}
