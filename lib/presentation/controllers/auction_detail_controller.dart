import 'package:get/get.dart';

import '../../application/services/action_log.dart';
import '../../application/services/format_service.dart';
import '../../domain/entities/entities.dart';
import '../../domain/usecases/usecases.dart';
import 'mixins/guarded_controller_mixin.dart';

class AuctionDetailController extends GetxController with GuardedControllerMixin {
  AuctionDetailController({
    required this.getAuctionByIdUseCase,
    required this.getBidsUseCase,
    required this.addBidUseCase,
    required this.formatService,
    required this.actionLog,
  });

  final GetAuctionByIdUseCase getAuctionByIdUseCase;
  final GetBidsUseCase getBidsUseCase;
  final AddBidUseCase addBidUseCase;
  final FormatService formatService;
  final ActionLog actionLog;

  final Rx<Auction?> auction = Rx<Auction?>(null);
  final RxList<Bid> bids = <Bid>[].obs;
  final RxBool isLoading = false.obs;

  Future<void> load(String id) async {
    isLoading.value = true;
    auction.value = await getAuctionByIdUseCase(id);
    bids.assignAll(await getBidsUseCase(id));
    isLoading.value = false;
  }

  Future<void> placeBid(String userId, double amount) async {
    final current = auction.value;
    if (current == null) {
      return;
    }
    final bid = Bid(
      id: 'bid_${DateTime.now().millisecondsSinceEpoch}',
      auctionId: current.id,
      userId: userId,
      amount: amount,
      time: DateTime.now(),
    );
    await addBidUseCase(current.id, bid);
    bids.insert(0, bid);
    actionLog.add('detail_bid:${current.id}:$amount');
  }
}
