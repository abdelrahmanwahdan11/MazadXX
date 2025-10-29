import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/wanted_controller.dart';
import '../widgets/skeleton.dart';
import '../widgets/swipe_deck.dart';
import '../widgets/wanted_card.dart';

class WantedPage extends GetView<WantedController> {
  const WantedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('wanted'.tr),
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
          if (controller.visibleItems.isEmpty) {
            return Center(child: Text('empty_state'.tr));
          }
          final width = MediaQuery.of(context).size.width;
          if (width < 600 && !controller.showGrid.value) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: SwipeDeck(
                items: controller.visibleItems,
                onSwipeRight: (item) => controller.toggleSaved(item.id),
                builder: (context, item) => WantedCard(
                  item: item,
                  onOffer: () {},
                  onSave: () => controller.toggleSaved(item.id),
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
              childAspectRatio: 0.8,
            ),
            itemCount: controller.visibleItems.length,
            itemBuilder: (context, index) {
              final item = controller.visibleItems[index];
              return WantedCard(
                item: item,
                onOffer: () {},
                onSave: () => controller.toggleSaved(item.id),
              );
            },
          );
        },
      ),
    );
  }
}
