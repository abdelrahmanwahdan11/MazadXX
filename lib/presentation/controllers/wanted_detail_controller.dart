import 'package:get/get.dart';

import '../../application/services/action_log.dart';
import '../../application/services/format_service.dart';
import '../../domain/entities/entities.dart';
import '../../domain/usecases/usecases.dart';

class WantedDetailController extends GetxController {
  WantedDetailController({
    required this.getWantedByIdUseCase,
    required this.getOffersUseCase,
    required this.addOfferUseCase,
    required this.formatService,
    required this.actionLog,
  });

  final GetWantedByIdUseCase getWantedByIdUseCase;
  final GetOffersUseCase getOffersUseCase;
  final AddOfferUseCase addOfferUseCase;
  final FormatService formatService;
  final ActionLog actionLog;

  final Rx<Wanted?> item = Rx<Wanted?>(null);
  final RxList<Offer> offers = <Offer>[].obs;
  final RxBool isLoading = false.obs;

  Future<void> load(String id) async {
    isLoading.value = true;
    item.value = await getWantedByIdUseCase(id);
    offers.assignAll(await getOffersUseCase(id));
    isLoading.value = false;
  }

  Future<void> addOffer(String userId, double amount, String message) async {
    final current = item.value;
    if (current == null) {
      return;
    }
    final offer = Offer(
      id: 'offer_${DateTime.now().millisecondsSinceEpoch}',
      wantedId: current.id,
      userId: userId,
      amount: amount,
      message: message,
      time: DateTime.now(),
    );
    await addOfferUseCase(current.id, offer);
    offers.insert(0, offer);
    actionLog.add('detail_offer:${current.id}:$amount');
  }
}
