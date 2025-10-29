import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../application/services/format_service.dart';
import '../controllers/watchlist_controller.dart';
import '../widgets/glass_card.dart';
import '../widgets/m3_segmented_button.dart';

class WatchlistPage extends StatefulWidget {
  const WatchlistPage({super.key});

  @override
  State<WatchlistPage> createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> {
  final WatchlistController controller = Get.find<WatchlistController>();
  final FormatService formatService = Get.find<FormatService>();
  final RxBool useGrid = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('watchlist'.tr),
        actions: [
          Obx(() {
            final count = controller.selected.length;
            if (count == 0) {
              return const SizedBox.shrink();
            }
            return TextButton(
              onPressed: controller.clearSelection,
              child: Text('clear_selection'.trParams({'count': '$count'})),
            );
          }),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                () => M3SegmentedButton<bool>(
                  segments: {false: 'list'.tr, true: 'grid'.tr},
                  selected: useGrid.value,
                  onChanged: (value) => useGrid.value = value,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Obx(() {
                  final auctions = controller.auctions;
                  final wanted = controller.wanted;
                  if (auctions.isEmpty && wanted.isEmpty) {
                    return Center(child: Text('watchlist_empty'.tr));
                  }
                  final entries = [
                    ...auctions.map(
                      (item) => _WatchEntry(
                        id: item.id,
                        title: item.title,
                        subtitle: '${item.location} • ${item.category}',
                        price: formatService.currency(item.currentBid),
                      ),
                    ),
                    ...wanted.map(
                      (item) => _WatchEntry(
                        id: item.id,
                        title: item.title,
                        subtitle: '${item.location} • ${item.category}',
                        price: formatService.currency(item.targetPrice),
                      ),
                    ),
                  ];
                  if (useGrid.value) {
                    return GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.1,
                      ),
                      itemCount: entries.length,
                      itemBuilder: (context, index) {
                        final entry = entries[index];
                        final selected = controller.selected.contains(entry.id);
                        return GestureDetector(
                          onTap: () => controller.toggleSelect(entry.id),
                          child: GlassCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(child: Text(entry.title, maxLines: 2, overflow: TextOverflow.ellipsis)),
                                    Checkbox(
                                      value: selected,
                                      onChanged: (_) => controller.toggleSelect(entry.id),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(entry.subtitle, style: Theme.of(context).textTheme.bodySmall),
                                const Spacer(),
                                Text(entry.price, style: Theme.of(context).textTheme.titleMedium),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                  return ListView.separated(
                    itemCount: entries.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final entry = entries[index];
                      final selected = controller.selected.contains(entry.id);
                      return GlassCard(
                        child: ListTile(
                          title: Text(entry.title),
                          subtitle: Text(entry.subtitle),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(entry.price),
                              const SizedBox(width: 12),
                              Checkbox(
                                value: selected,
                                onChanged: (_) => controller.toggleSelect(entry.id),
                              ),
                            ],
                          ),
                          onTap: () => controller.toggleSelect(entry.id),
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WatchEntry {
  const _WatchEntry({required this.id, required this.title, required this.subtitle, required this.price});

  final String id;
  final String title;
  final String subtitle;
  final String price;
}
