import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/wallet_controller.dart';
import '../widgets/glass_card.dart';

class WalletPage extends GetView<WalletController> {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('wallet'.tr)),
      body: SafeArea(
        child: Obx(() {
          final balance = controller.balance.value;
          final transactions = controller.transactions;
          final coupons = controller.coupons;
          final applied = controller.appliedCoupon.value;
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('balance'.tr, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text(controller.formatService.currency(balance), style: Theme.of(context).textTheme.headlineLarge),
                    const SizedBox(height: 12),
                    Text('wallet_hint'.tr),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('transactions'.tr, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 12),
                    ...transactions.map(
                      (entry) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(entry['label'].toString().tr),
                        subtitle: Text(controller.formatService.dateTimeShort(entry['time'] as DateTime)),
                        trailing: Text(controller.formatService.currency(entry['amount'] as num)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('coupons'.tr, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 12),
                    ...coupons.map(
                      (coupon) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(coupon.code),
                        subtitle: Text('${coupon.discount}% • ${controller.formatService.dateTimeShort(coupon.expires)}'),
                        trailing: applied == coupon.code
                            ? Chip(label: Text('applied'.tr))
                            : TextButton(
                                onPressed: () => controller.applyCoupon(coupon),
                                child: Text('apply_coupon'.tr),
                              ),
                      ),
                    ),
                    if (applied.isNotEmpty)
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: controller.resetCoupon,
                          child: Text('reset_coupon'.tr),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
