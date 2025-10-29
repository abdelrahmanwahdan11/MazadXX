import 'dart:async';

import 'package:get/get.dart';

import '../../application/services/index_service.dart';
import '../../application/services/local_store.dart';
import '../../domain/entities/entities.dart';
import '../../domain/repositories/repositories.dart' as domain;
import '../../domain/usecases/usecases.dart';
import 'mixins/guarded_controller_mixin.dart';

class SearchController extends GetxController with GuardedControllerMixin {
  SearchController({
    required this.auctionsUseCase,
    required this.wantedUseCase,
    required this.indexService,
    required this.localStore,
    required this.userRepository,
  });

  final GetAuctionsUseCase auctionsUseCase;
  final GetWantedUseCase wantedUseCase;
  final IndexService indexService;
  final LocalStore localStore;
  final domain.UserRepository userRepository;

  final RxString query = ''.obs;
  final RxList<Auction> auctionResults = <Auction>[].obs;
  final RxList<Wanted> wantedResults = <Wanted>[].obs;
  final RxList<String> recentSearches = <String>[].obs;
  final RxString mode = 'all'.obs;
  Timer? _debounce;

  List<Auction> _auctions = <Auction>[];
  List<Wanted> _wanted = <Wanted>[];
  Map<String, User> _users = <String, User>{};

  @override
  void onInit() {
    super.onInit();
    _loadRecent();
    _prime();
  }

  Future<void> _prime() async {
    _auctions = await auctionsUseCase();
    _wanted = await wantedUseCase();
    _users = {for (final user in await userRepository.fetchAll()) user.id: user};
  }

  void updateQuery(String value) {
    query.value = value;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), performSearch);
    trackTimer(_debounce!);
  }

  Future<void> performSearch() async {
    final term = query.value.trim();
    if (term.isEmpty) {
      auctionResults.clear();
      wantedResults.clear();
      return;
    }
    final ids = indexService.searchAuctions(_auctions, term, users: _users);
    final lookupAuctions = {for (final item in _auctions) item.id: item};
    auctionResults.assignAll(ids.map((String id) => lookupAuctions[id]).whereType<Auction>());

    final wantedIds = indexService.searchWanted(_wanted, term, users: _users);
    final lookupWanted = {for (final item in _wanted) item.id: item};
    wantedResults.assignAll(wantedIds.map((String id) => lookupWanted[id]).whereType<Wanted>());
    _storeRecent(term);
  }

  void switchMode(String value) {
    mode.value = value;
  }

  void _loadRecent() {
    final saved = localStore.readList('recent_searches').whereType<String>().toList();
    recentSearches.assignAll(saved.take(10));
  }

  Future<void> _storeRecent(String term) async {
    final entries = <String>[term, ...recentSearches.where((String e) => e != term)];
    recentSearches.assignAll(entries.take(10));
    await localStore.writeList('recent_searches', recentSearches.toList());
  }

  @override
  void onClose() {
    cancelTimers();
    super.onClose();
  }
}
