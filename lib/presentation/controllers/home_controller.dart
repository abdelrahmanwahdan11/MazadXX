import 'package:get/get.dart';

import '../../application/services/format_service.dart';
import '../../application/services/index_service.dart';
import '../../domain/entities/entities.dart';
import '../../domain/repositories/repositories.dart';
import '../../domain/usecases/usecases.dart';

class HomeController extends GetxController {
  HomeController({
    required this.featuredAuctions,
    required this.auctionsUseCase,
    required this.wantedUseCase,
    required this.categoriesUseCase,
    required this.formatService,
    required this.indexService,
    required this.userRepository,
  });

  final GetFeaturedAuctionsUseCase featuredAuctions;
  final GetAuctionsUseCase auctionsUseCase;
  final GetWantedUseCase wantedUseCase;
  final GetCategoriesUseCase categoriesUseCase;
  final FormatService formatService;
  final IndexService indexService;
  final domain.UserRepository userRepository;

  final RxBool isLoading = false.obs;
  final RxList<Auction> heroAuctions = <Auction>[].obs;
  final RxList<Auction> endingSoon = <Auction>[].obs;
  final RxList<Auction> newArrivals = <Auction>[].obs;
  final RxList<Auction> popular = <Auction>[].obs;
  final RxList<Wanted> spotlightWanted = <Wanted>[].obs;
  final RxList<Category> categories = <Category>[].obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    final users = await userRepository.fetchAll();
    final auctions = await auctionsUseCase();
    final wanted = await wantedUseCase();
    categories.assignAll(await categoriesUseCase());
    heroAuctions.assignAll(await featuredAuctions());

    final sortedEnding = auctions.toList()
      ..sort((Auction a, Auction b) => a.endTime.compareTo(b.endTime));
    endingSoon.assignAll(sortedEnding.take(6));

    final newOnes = auctions.toList()
      ..sort((Auction a, Auction b) => b.startPrice.compareTo(a.startPrice));
    newArrivals.assignAll(newOnes.take(6));

    final popularIds = indexService.searchAuctions(auctions, 'popular', users: {for (final user in users) user.id: user});
    if (popularIds.isEmpty) {
      final byWatchers = auctions.toList()
        ..sort((Auction a, Auction b) => b.watchers.compareTo(a.watchers));
      popular.assignAll(byWatchers.take(6));
    } else {
      final map = {for (final auction in auctions) auction.id: auction};
      popular.assignAll(popularIds.map((String id) => map[id]).whereType<Auction>().take(6));
    }

    spotlightWanted.assignAll(wanted.take(6));
    isLoading.value = false;
  }
}
