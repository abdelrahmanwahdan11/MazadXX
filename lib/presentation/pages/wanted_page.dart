import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/routes/app_routes.dart';
import '../../domain/entities/entities.dart';
import '../controllers/wanted_controller.dart';
import '../widgets/app_shell.dart';
import '../widgets/m3_search_bar.dart';
import '../widgets/section_header.dart';
import '../widgets/skeleton.dart';
import '../widgets/swipe_deck.dart';
import '../widgets/wanted_card.dart';

class WantedPage extends GetView<WantedController> {
  const WantedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShell(
      currentRoute: AppRoutes.wanted,
      child: SafeArea(
        child: RefreshIndicator(
          onRefresh: controller.refreshList,
          child: Obx(() {
            if (controller.isLoading.value && controller.visibleItems.isEmpty) {
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
                        FilledButton.tonal(
                          onPressed: () => Get.toNamed(AppRoutes.search),
                          child: Text('search'.tr),
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
        SectionHeader(titleKey: 'wanted'),
        const SizedBox(height: 16),
        SizedBox(
          height: 380,
          child: SwipeDeck<Wanted>(
            items: controller.visibleItems,
            builder: (context, item) => WantedCard(
              item: item,
              formatService: controller.formatService,
              onOffer: () => Get.toNamed(AppRoutes.wantedDetails.replaceFirst(':id', item.id)),
              onSave: () => controller.toggleSaved(item.id),
              onInfo: () => Get.toNamed(AppRoutes.wantedDetails.replaceFirst(':id', item.id)),
              isSaved: controller.isSaved(item.id),
            ),
            onLike: controller.recordLike,
            onPass: controller.recordPass,
            onInfo: (item) => Get.toNamed(AppRoutes.wantedDetails.replaceFirst(':id', item.id)),
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
          itemCount: controller.visibleItems.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.78,
          ),
          itemBuilder: (context, index) {
            final item = controller.visibleItems[index];
            return WantedCard(
              item: item,
              formatService: controller.formatService,
              onOffer: () => Get.toNamed(AppRoutes.wantedDetails.replaceFirst(':id', item.id)),
              onSave: () => controller.toggleSaved(item.id),
              onInfo: () => Get.toNamed(AppRoutes.wantedDetails.replaceFirst(':id', item.id)),
              isSaved: controller.isSaved(item.id),
            );
          },
        );
      }),
    );
  }
}
