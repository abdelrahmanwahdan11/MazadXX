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

class AuctionsController extends GetxController with GuardedControllerMixin {
  AuctionsController({
    required this.auctionsUseCase,
    required this.bidsUseCase,
    required this.addBidUseCase,
    required this.userRepository,
    required this.indexService,
    required this.actionLog,
    required this.localStore,
    required this.formatService,
  });

  final GetAuctionsUseCase auctionsUseCase;
  final GetBidsUseCase bidsUseCase;
  final AddBidUseCase addBidUseCase;
  final domain.UserRepository userRepository;
  final IndexService indexService;
  final ActionLog actionLog;
  final LocalStore localStore;
  final FormatService formatService;

  final RxList<Auction> _auctions = <Auction>[].obs;
  final RxList<Auction> _filtered = <Auction>[].obs;
  final RxList<Auction> visibleAuctions = <Auction>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isRefreshing = false.obs;
  final RxBool showGrid = false.obs;
  final RxString searchTerm = ''.obs;
  final RxMap<String, dynamic> activeFilters = <String, dynamic>{}.obs;
  final RxSet<String> watchlist = <String>{}.obs;
  final RxInt currentPage = 0.obs;
  final int pageSize = 12;

  Map<String, User> _users = <String, User>{};
  Timer? _debounce;
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_handleScroll);
    _loadWatchlist();
    load();
  }

  Future<void> load({bool refresh = false}) async {
    if (isLoading.value) return;
    isLoading.value = true;
    _users = {for (final user in await userRepository.fetchAll()) user.id: user};
    final items = await auctionsUseCase(refresh: refresh);
    _auctions.assignAll(items);
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
    final nextItems = _filtered.skip(currentPage.value * pageSize).take(pageSize).toList();
    visibleAuctions.addAll(nextItems);
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

  Future<List<Bid>> loadBids(String auctionId) {
    return bidsUseCase(auctionId);
  }

  Future<void> placeBid(Auction auction, double amount, String userId) async {
    final bid = Bid(
      id: 'bid_${DateTime.now().millisecondsSinceEpoch}',
      auctionId: auction.id,
      userId: userId,
      amount: amount,
      time: DateTime.now(),
    );
    await addBidUseCase(auction.id, bid);
    actionLog.add('bid:${auction.id}:$amount');
    await refreshList();
  }

  bool isInWatchlist(String id) => watchlist.contains(id);

  Future<void> toggleWatchlist(String id) async {
    if (watchlist.contains(id)) {
      watchlist.remove(id);
      actionLog.add('watchlist_remove:$id');
    } else {
      watchlist.add(id);
      actionLog.add('watchlist_add:$id');
    }
    await localStore.writeList('watchlist', watchlist.toList());
  }

  void recordLike(Auction auction) {
    toggleWatchlist(auction.id);
  }

  void recordPass(Auction auction) {
    actionLog.add('pass:${auction.id}');
  }

  void _loadWatchlist() {
    final stored = localStore.readList('watchlist');
    watchlist.addAll(stored.whereType<String>());
  }

  void _applyFilters({required bool resetPage}) {
    final query = searchTerm.value;
    var results = _auctions.toList();

    if (activeFilters.containsKey('category')) {
      final categories = List<String>.from(activeFilters['category'] as List? ?? <String>[]);
      if (categories.isNotEmpty) {
        results = results.where((Auction item) => categories.contains(item.category)).toList();
      }
    }

    final minPrice = (activeFilters['priceMin'] as num?)?.toDouble();
    final maxPrice = (activeFilters['priceMax'] as num?)?.toDouble();
    if (minPrice != null) {
      results = results.where((Auction item) => item.currentBid >= minPrice).toList();
    }
    if (maxPrice != null) {
      results = results.where((Auction item) => item.currentBid <= maxPrice).toList();
    }

    if (query.isNotEmpty) {
      final ids = indexService.searchAuctions(results, query, users: _users);
      final lookup = {for (final item in results) item.id: item};
      results = ids.map((String id) => lookup[id]).whereType<Auction>().toList();
    }

    _filtered.assignAll(results);
    if (resetPage) {
      currentPage.value = 0;
      visibleAuctions.assignAll(_filtered.take(pageSize).toList());
    } else {
      final start = currentPage.value * pageSize;
      visibleAuctions.assignAll(_filtered.skip(start).take(pageSize * (currentPage.value + 1)).toList());
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
