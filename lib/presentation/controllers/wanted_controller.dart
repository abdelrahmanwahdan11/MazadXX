import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../application/services/action_log.dart';
import '../../application/services/format_service.dart';
import '../../application/services/index_service.dart';
import '../../application/services/local_store.dart';
import '../../domain/entities/entities.dart';
import '../../domain/repositories/repositories.dart';
import '../../domain/usecases/usecases.dart';
import 'mixins/guarded_controller_mixin.dart';

class WantedController extends GetxController with GuardedControllerMixin {
  WantedController({
    required this.wantedUseCase,
    required this.offersUseCase,
    required this.addOfferUseCase,
    required this.userRepository,
    required this.indexService,
    required this.actionLog,
    required this.localStore,
    required this.formatService,
  });

  final GetWantedUseCase wantedUseCase;
  final GetOffersUseCase offersUseCase;
  final AddOfferUseCase addOfferUseCase;
  final domain.UserRepository userRepository;
  final IndexService indexService;
  final ActionLog actionLog;
  final LocalStore localStore;
  final FormatService formatService;

  final RxList<Wanted> _items = <Wanted>[].obs;
  final RxList<Wanted> _filtered = <Wanted>[].obs;
  final RxList<Wanted> visibleItems = <Wanted>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool showGrid = false.obs;
  final RxBool isRefreshing = false.obs;
  final RxString searchTerm = ''.obs;
  final RxMap<String, dynamic> activeFilters = <String, dynamic>{}.obs;
  final RxSet<String> saved = <String>{}.obs;
  final RxInt currentPage = 0.obs;
  final int pageSize = 12;

  Map<String, User> _users = <String, User>{};
  Timer? _debounce;
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_handleScroll);
    _loadSaved();
    load();
  }

  Future<void> load({bool refresh = false}) async {
    if (isLoading.value) return;
    isLoading.value = true;
    _users = {for (final user in await userRepository.fetchAll()) user.id: user};
    final data = await wantedUseCase(refresh: refresh);
    _items.assignAll(data);
    _applyFilters(resetPage: true);
    isLoading.value = false;
  }

  Future<void> refreshList() async {
    isRefreshing.value = true;
    await load(refresh: true);
    isRefreshing.value = false;
  }

  void toggleLayout() {
    showGrid.toggle();
  }

  void search(String value) {
    searchTerm.value = value;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () {
      _applyFilters(resetPage: true);
    });
    trackTimer(_debounce!);
  }

  void updateFilters(Map<String, dynamic> filters) {
    activeFilters.assignAll(filters);
    _applyFilters(resetPage: true);
  }

  void clearFilters() {
    activeFilters.clear();
    _applyFilters(resetPage: true);
  }

  void loadMore() {
    if (((currentPage.value + 1) * pageSize) >= _filtered.length) {
      return;
    }
    currentPage.value++;
    visibleItems.addAll(_filtered.skip(currentPage.value * pageSize).take(pageSize));
  }

  void _handleScroll() {
    if (!scrollController.hasClients) {
      return;
    }
    final position = scrollController.position;
    if (position.maxScrollExtent <= 0) {
      return;
    }
    if (position.pixels >= position.maxScrollExtent * 0.85) {
      loadMore();
    }
  }

  Future<List<Offer>> loadOffers(String wantedId) {
    return offersUseCase(wantedId);
  }

  Future<void> sendOffer(Wanted item, double amount, String message, String userId) async {
    final offer = Offer(
      id: 'offer_${DateTime.now().millisecondsSinceEpoch}',
      wantedId: item.id,
      userId: userId,
      amount: amount,
      message: message,
      time: DateTime.now(),
    );
    await addOfferUseCase(item.id, offer);
    actionLog.add('offer:${item.id}:$amount');
  }

  bool isSaved(String id) => saved.contains(id);

  Future<void> toggleSaved(String id) async {
    if (saved.contains(id)) {
      saved.remove(id);
      actionLog.add('saved_remove:$id');
    } else {
      saved.add(id);
      actionLog.add('saved_add:$id');
    }
    await localStore.writeList('wanted_saved', saved.toList());
  }

  void recordLike(Wanted item) {
    toggleSaved(item.id);
  }

  void recordPass(Wanted item) {
    actionLog.add('wanted_pass:${item.id}');
  }

  void _loadSaved() {
    final entries = localStore.readList('wanted_saved');
    saved.addAll(entries.whereType<String>());
  }

  void _applyFilters({required bool resetPage}) {
    final query = searchTerm.value;
    var results = _items.toList();

    if (activeFilters.containsKey('location')) {
      final location = activeFilters['location'] as String?;
      if (location != null && location.isNotEmpty) {
        results = results.where((Wanted item) => item.location.toLowerCase().contains(location.toLowerCase())).toList();
      }
    }

    if (activeFilters.containsKey('category')) {
      final categories = List<String>.from(activeFilters['category'] as List? ?? <String>[]);
      if (categories.isNotEmpty) {
        results = results.where((Wanted item) => categories.contains(item.category)).toList();
      }
    }

    final minPrice = (activeFilters['priceMin'] as num?)?.toDouble();
    final maxPrice = (activeFilters['priceMax'] as num?)?.toDouble();
    if (minPrice != null) {
      results = results.where((Wanted item) => item.targetPrice >= minPrice).toList();
    }
    if (maxPrice != null) {
      results = results.where((Wanted item) => item.targetPrice <= maxPrice).toList();
    }

    if (query.isNotEmpty) {
      final ids = indexService.searchWanted(results, query, users: _users);
      final lookup = {for (final item in results) item.id: item};
      results = ids.map((String id) => lookup[id]).whereType<Wanted>().toList();
    }

    _filtered.assignAll(results);
    if (resetPage) {
      currentPage.value = 0;
      visibleItems.assignAll(_filtered.take(pageSize).toList());
    } else {
      final start = currentPage.value * pageSize;
      visibleItems.assignAll(_filtered.skip(start).take(pageSize * (currentPage.value + 1)).toList());
    }
  }

  @override
  void onClose() {
    scrollController.removeListener(_handleScroll);
    scrollController.dispose();
    cancelTimers();
    super.onClose();
  }
}
