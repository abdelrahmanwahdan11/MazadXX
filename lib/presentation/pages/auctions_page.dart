import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/routes/app_routes.dart';
import '../../domain/entities/entities.dart';
import '../controllers/auctions_controller.dart';
import '../widgets/app_shell.dart';
import '../widgets/auction_card.dart';
import '../widgets/m3_search_bar.dart';
import '../widgets/m3_segmented_button.dart';
import '../widgets/section_header.dart';
import '../widgets/skeleton.dart';
import '../widgets/swipe_deck.dart';

class AuctionsPage extends GetView<AuctionsController> {
  const AuctionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShell(
      currentRoute: AppRoutes.auctions,
      child: SafeArea(
        child: RefreshIndicator(
          onRefresh: controller.refreshList,
          child: Obx(() {
            if (controller.isLoading.value && controller.visibleAuctions.isEmpty) {
              return const Center(child: Skeleton(height: 160));
            }
            return LayoutBuilder(
              builder: (context, constraints) {
                final isMobile = constraints.maxWidth < 720;
                return ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    M3SearchBar(
                      hintText: 'search'.tr,
                      onChanged: controller.search,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        FilledButton.tonal(
                          onPressed: () => Get.toNamed(AppRoutes.filters),
                          child: Text('filters'.tr),
                        ),
                        const SizedBox(width: 12),
                        Obx(
                          () => M3SegmentedButton<bool>(
                            segments: {true: 'grid'.tr, false: 'list'.tr},
                            selected: controller.showGrid.value,
                            onChanged: (value) => controller.showGrid.value = value,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    if (isMobile && !controller.showGrid.value)
                      _buildSwipeDeck(context)
                    else
                      _buildGrid(context),
                  ],
                );
              },
            );
          }),
        ),
      ),
    );
  }

  Widget _buildSwipeDeck(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(titleKey: 'browse'),
        const SizedBox(height: 16),
        SizedBox(
          height: 420,
          child: SwipeDeck<Auction>(
            items: controller.visibleAuctions,
            builder: (context, item) => AuctionCard(
              item: item,
              formatService: controller.formatService,
              onBid: () => Get.toNamed(AppRoutes.auctionDetails.replaceFirst(':id', item.id)),
              onWatch: () => controller.toggleWatchlist(item.id),
              onInfo: () => Get.toNamed(AppRoutes.auctionDetails.replaceFirst(':id', item.id)),
              isWatchlisted: controller.isInWatchlist(item.id),
            ),
            onLike: controller.recordLike,
            onPass: controller.recordPass,
            onInfo: (item) => Get.toNamed(AppRoutes.auctionDetails.replaceFirst(':id', item.id)),
          ),
        ),
      ],
    );
  }

  Widget _buildGrid(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification.metrics.pixels > notification.metrics.maxScrollExtent * 0.85) {
          controller.loadMore();
        }
        return false;
      },
      child: Obx(() {
        final columns = (MediaQuery.of(context).size.width ~/ 320).clamp(2, 4);
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.visibleAuctions.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.72,
          ),
          itemBuilder: (context, index) {
            final item = controller.visibleAuctions[index];
            return AuctionCard(
              item: item,
              formatService: controller.formatService,
              onBid: () => Get.toNamed(AppRoutes.auctionDetails.replaceFirst(':id', item.id)),
              onWatch: () => controller.toggleWatchlist(item.id),
              onInfo: () => Get.toNamed(AppRoutes.auctionDetails.replaceFirst(':id', item.id)),
              isWatchlisted: controller.isInWatchlist(item.id),
            );
          },
        );
      }),
    );
  }
}
