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
                final width = constraints.maxWidth;
                final isPhone = width < 600;
                final useSwipeDeck = isPhone && !controller.showGrid.value;
                final scrollController = controller.scrollController;
                return Scrollbar.adaptive(
                  controller: scrollController,
                  thumbVisibility: !isPhone,
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(24),
                    children: [
                      M3SearchBar(
                        hintText: 'search'.tr,
                        onChanged: controller.search,
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          FilledButton.tonal(
                            onPressed: () => Get.toNamed(AppRoutes.filters),
                            child: Text('filters'.tr),
                          ),
                          FilledButton.tonal(
                            onPressed: () => Get.toNamed(AppRoutes.search),
                            child: Text('search'.tr),
                          ),
                          if (isPhone)
                            M3SegmentedButton<bool>(
                              segments: {false: 'list'.tr, true: 'grid'.tr},
                              selected: controller.showGrid.value,
                              onChanged: (value) => controller.showGrid.value = value,
                            ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      if (useSwipeDeck)
                        _buildSwipeDeck(context)
                      else
                        _buildGrid(context, width),
                    ],
                  ),
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

  Widget _buildGrid(BuildContext context, double width) {
    return Obx(() {
      final columns = _gridColumns(width);
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
          return GridTile(
            child: WantedCard(
              item: item,
              formatService: controller.formatService,
              onOffer: () => Get.toNamed(AppRoutes.wantedDetails.replaceFirst(':id', item.id)),
              onSave: () => controller.toggleSaved(item.id),
              onInfo: () => Get.toNamed(AppRoutes.wantedDetails.replaceFirst(':id', item.id)),
              isSaved: controller.isSaved(item.id),
            ),
          );
        },
      );
    });
  }

  int _gridColumns(double width) {
    if (width < 600) {
      return 2;
    }
    if (width < 1024) {
      return 3;
    }
    return 4;
  }
}
