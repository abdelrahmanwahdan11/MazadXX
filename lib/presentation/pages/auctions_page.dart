import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auctions_controller.dart';
import '../widgets/auction_card.dart';
import '../widgets/skeleton.dart';
import '../widgets/swipe_deck.dart';

class AuctionsPage extends GetView<AuctionsController> {
  const AuctionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('auctions'.tr),
        actions: [
          Obx(
            () => IconButton(
              icon: Icon(controller.showGrid.value ? Icons.view_agenda : Icons.grid_view),
              onPressed: controller.toggleLayout,
            ),
          ),
        ],
      ),
      body: Obx(
        () {
          if (controller.isLoading.value) {
            return const Center(child: Skeleton(height: 120));
          }
          if (controller.visibleAuctions.isEmpty) {
            return Center(child: Text('empty_state'.tr));
          }
          final width = MediaQuery.of(context).size.width;
          if (width < 600 && !controller.showGrid.value) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: SwipeDeck(
                items: controller.visibleAuctions,
                onSwipeRight: (item) => controller.toggleWatchlist(item.id),
                builder: (context, item) => AuctionCard(
                  item: item,
                  onBid: () {},
                  onWatch: () => controller.toggleWatchlist(item.id),
                ),
              ),
            );
          }
          final crossAxisCount = width > 1200
              ? 4
              : width > 900
                  ? 3
                  : 2;
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.68,
            ),
            itemCount: controller.visibleAuctions.length,
            itemBuilder: (context, index) {
              final item = controller.visibleAuctions[index];
              return AuctionCard(
                item: item,
                onBid: () {},
                onWatch: () => controller.toggleWatchlist(item.id),
              );
            },
          );
        },
      ),
    );
  }
}
