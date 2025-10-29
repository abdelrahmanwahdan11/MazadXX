import 'package:get/get.dart';

import '../../application/services/format_service.dart';
import '../../application/services/local_store.dart';
import '../../domain/entities/entities.dart';

class WalletController extends GetxController {
  WalletController({required this.localStore, required this.formatService});

  final LocalStore localStore;
  final FormatService formatService;

  final RxDouble balance = 1250.0.obs;
  final RxList<Map<String, dynamic>> transactions = <Map<String, dynamic>>[].obs;
  final RxList<Coupon> coupons = <Coupon>[].obs;
  final RxString appliedCoupon = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  void _load() {
    final stored = localStore.readList('transactions');
    if (stored.isEmpty) {
      transactions.assignAll(<Map<String, dynamic>>[
        <String, dynamic>{'label': 'wallet_recharge', 'amount': 500.0, 'time': DateTime.now().subtract(const Duration(days: 2))},
        <String, dynamic>{'label': 'wallet_bid', 'amount': -320.0, 'time': DateTime.now().subtract(const Duration(days: 1))},
        <String, dynamic>{'label': 'wallet_payout', 'amount': 210.0, 'time': DateTime.now().subtract(const Duration(hours: 5))},
      ]);
    } else {
      transactions.assignAll(stored.whereType<Map<String, dynamic>>());
    }
    coupons.assignAll(<Coupon>[
      Coupon(code: 'SAVE20', discount: 20, expires: DateTime.now().add(const Duration(days: 14))),
      Coupon(code: 'FREESHIP', discount: 15, expires: DateTime.now().add(const Duration(days: 5))),
    ]);
  }

  void applyCoupon(Coupon coupon) {
    appliedCoupon.value = coupon.code;
  }

  void resetCoupon() {
    appliedCoupon.value = '';
  }
}
