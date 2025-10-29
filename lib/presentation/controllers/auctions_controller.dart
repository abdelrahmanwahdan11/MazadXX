import 'package:get/get.dart';

import '../../application/services/action_log.dart';
import '../../application/services/format_service.dart';
import '../../application/services/index_service.dart';
import '../../data/models/auction_item.dart';
import '../../data/repositories/auction_repository.dart';
import 'mixins/guarded_controller_mixin.dart';

class AuctionsController extends GetxController with GuardedControllerMixin {
  AuctionsController({
    required this.auctionRepository,
    required this.indexService,
    required this.actionLog,
  });

  final AuctionRepository auctionRepository;
  final IndexService indexService;
  final ActionLog actionLog;

  final RxList<AuctionItem> _auctions = <AuctionItem>[].obs;
  final RxList<AuctionItem> visibleAuctions = <AuctionItem>[].obs;
  final RxString searchTerm = ''.obs;
  final RxBool isLoading = false.obs;
  final RxBool isRefreshing = false.obs;
  final RxBool showGrid = false.obs;
  final Rx<Set<String>> _watchlist = <String>{}.obs;

  final FormatService formatService = FormatService();

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    final items = await auctionRepository.fetchAuctions();
    _auctions.assignAll(items);
    _applySearch();
    isLoading.value = false;
  }

  Future<void> refreshList() async {
    isRefreshing.value = true;
    await load();
    isRefreshing.value = false;
  }

  void toggleLayout() {
    showGrid.toggle();
  }

  void search(String value) {
    searchTerm.value = value;
    _applySearch();
  }

  void _applySearch() {
    final ids = indexService.searchAuctions(_auctions, searchTerm.value);
    final mapped = <AuctionItem>[];
    for (final id in ids) {
      final match = _findById(id);
      if (match != null) {
        mapped.add(match);
      }
    }
    visibleAuctions.assignAll(mapped);
  }

  AuctionItem? _findById(String id) {
    for (final item in _auctions) {
      if (item.id == id) {
        return item;
      }
    }
    return null;
  }

  bool isInWatchlist(String id) => _watchlist.contains(id);

  void toggleWatchlist(String id) {
    if (_watchlist.contains(id)) {
      _watchlist.remove(id);
      actionLog.add('Removed $id from watchlist');
    } else {
      _watchlist.add(id);
      actionLog.add('Added $id to watchlist');
    }
  }
  @override
  void onClose() {
    cancelTimers();
    super.onClose();
  }
}
