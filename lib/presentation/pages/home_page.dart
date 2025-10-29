import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_theme.dart';
import '../controllers/home_controller.dart';
import '../widgets/auction_card.dart';
import '../widgets/glass_card.dart';
import '../widgets/skeleton.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: Text('browse'.tr), backgroundColor: Colors.transparent, elevation: 0),
      body: Stack(
        children: [
          Container(decoration: AppTheme.heroBackground()),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Obx(
                () {
                  if (controller.isLoading.value) {
                    return const Center(child: Skeleton(height: 120));
                  }
                  if (controller.featuredAuctions.isEmpty) {
                    return Center(child: Text('empty_state'.tr));
                  }
                  return ListView(
                    children: [
                      Text('auctions'.tr, style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: 12),
                      GlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('ending_soon'.tr, style: Theme.of(context).textTheme.titleLarge),
                            const SizedBox(height: 12),
                            SizedBox(
                              height: 260,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  final item = controller.featuredAuctions[index];
                                  return SizedBox(
                                    width: 240,
                                    child: AuctionCard(
                                      item: item,
                                      onBid: () {},
                                      onWatch: () {},
                                    ),
                                  );
                                },
                                separatorBuilder: (_, __) => const SizedBox(width: 16),
                                itemCount: controller.featuredAuctions.length,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
