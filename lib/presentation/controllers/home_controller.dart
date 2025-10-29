import 'package:get/get.dart';

import '../../data/models/auction_item.dart';
import '../../data/repositories/auction_repository.dart';

class HomeController extends GetxController {
  HomeController({required this.auctionRepository});

  final AuctionRepository auctionRepository;

  final RxList<AuctionItem> featuredAuctions = <AuctionItem>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    final items = await auctionRepository.fetchAuctions();
    featuredAuctions.assignAll(items.take(4).toList());
    isLoading.value = false;
  }
}
