import 'package:get/get.dart';

import '../../application/services/local_store.dart';
import '../../domain/entities/entities.dart';
import '../../domain/usecases/usecases.dart';

class WatchlistController extends GetxController {
  WatchlistController({
    required this.localStore,
    required this.auctionsUseCase,
    required this.wantedUseCase,
  });

  final LocalStore localStore;
  final GetAuctionsUseCase auctionsUseCase;
  final GetWantedUseCase wantedUseCase;

  final RxList<Auction> auctions = <Auction>[].obs;
  final RxList<Wanted> wanted = <Wanted>[].obs;
  final RxSet<String> selected = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    final watchIds = localStore.readList('watchlist').whereType<String>().toSet();
    final savedWanted = localStore.readList('wanted_saved').whereType<String>().toSet();
    final auctionData = await auctionsUseCase();
    final wantedData = await wantedUseCase();
    auctions.assignAll(auctionData.where((Auction item) => watchIds.contains(item.id)).toList());
    wanted.assignAll(wantedData.where((Wanted item) => savedWanted.contains(item.id)).toList());
  }

  void toggleSelect(String id) {
    if (selected.contains(id)) {
      selected.remove(id);
    } else {
      selected.add(id);
    }
  }

  void clearSelection() {
    selected.clear();
  }
}
