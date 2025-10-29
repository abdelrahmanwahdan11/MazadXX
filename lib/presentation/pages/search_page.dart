import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../application/services/format_service.dart';
import '../../core/routes/app_routes.dart';
import '../controllers/search_controller.dart';
import '../widgets/glass_card.dart';
import '../widgets/m3_search_bar.dart';
import '../widgets/m3_segmented_button.dart';
import '../widgets/section_header.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final SearchController controller = Get.find<SearchController>();
  final FormatService formatService = Get.find<FormatService>();
  final TextEditingController queryController = TextEditingController();

  @override
  void dispose() {
    queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('search'.tr)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            M3SearchBar(
              controller: queryController,
              hintText: 'search'.tr,
              onChanged: controller.updateQuery,
              onSubmitted: (_) => controller.performSearch(),
            ),
            const SizedBox(height: 16),
            Obx(
              () => M3SegmentedButton<String>(
                segments: {
                  'all': 'all'.tr,
                  'auctions': 'auctions'.tr,
                  'wanted': 'wanted'.tr,
                },
                selected: controller.mode.value,
                onChanged: controller.switchMode,
              ),
            ),
            const SizedBox(height: 16),
            Text('recent_searches'.tr, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Obx(
              () => Wrap(
                spacing: 12,
                children: controller.recentSearches
                    .map(
                      (term) => ActionChip(
                        label: Text(term),
                        onPressed: () {
                          queryController.text = term;
                          controller.updateQuery(term);
                          controller.performSearch();
                        },
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 24),
            SectionHeader(titleKey: 'results'),
            const SizedBox(height: 12),
            Obx(() {
              final mode = controller.mode.value;
              final auctions = controller.auctionResults;
              final wanted = controller.wantedResults;
              if (mode == 'auctions' && auctions.isEmpty) {
                return Center(child: Text('no_results'.tr));
              }
              if (mode == 'wanted' && wanted.isEmpty) {
                return Center(child: Text('no_results'.tr));
              }
              if (mode == 'all' && auctions.isEmpty && wanted.isEmpty) {
                return Center(child: Text('no_results'.tr));
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (mode != 'wanted')
                    GlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('auctions'.tr, style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 8),
                          ...auctions.map(
                            (item) => ListTile(
                              title: Text(item.title),
                              subtitle: Text('${item.location} • ${item.category}'),
                              trailing: Text(formatService.currency(item.currentBid)),
                              onTap: () => Get.toNamed(AppRoutes.auctionDetails.replaceFirst(':id', item.id)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (mode != 'auctions')
                    Padding(
                      padding: EdgeInsets.only(top: mode == 'all' ? 16 : 0),
                      child: GlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('wanted'.tr, style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 8),
                            ...wanted.map(
                              (item) => ListTile(
                                title: Text(item.title),
                                subtitle: Text('${item.location} • ${item.category}'),
                                trailing: Text(formatService.currency(item.targetPrice)),
                                onTap: () => Get.toNamed(AppRoutes.wantedDetails.replaceFirst(':id', item.id)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
