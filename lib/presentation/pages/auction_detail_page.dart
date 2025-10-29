import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/entities/entities.dart';
import '../controllers/auction_detail_controller.dart';
import '../widgets/auction_timer.dart';
import '../widgets/glass_card.dart';
import '../widgets/parallax_header.dart';
import '../widgets/section_header.dart';

class AuctionDetailPage extends StatefulWidget {
  const AuctionDetailPage({super.key});

  @override
  State<AuctionDetailPage> createState() => _AuctionDetailPageState();
}

class _AuctionDetailPageState extends State<AuctionDetailPage> {
  final AuctionDetailController controller = Get.find<AuctionDetailController>();
  String? _loadedId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final id = Get.parameters['id'];
    if (id != null && id != _loadedId) {
      _loadedId = id;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.load(id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        final isLoading = controller.isLoading.value;
        final auction = controller.auction.value;
        if (isLoading && auction == null) {
          return const Center(child: CircularProgressIndicator());
        }
        if (auction == null) {
          return Center(child: Text('empty_state'.tr));
        }
        return CustomScrollView(
          slivers: [
            ParallaxHeader(
              image: auction.images.isNotEmpty ? auction.images.first : null,
              title: Text(auction.title),
              subtitle: Text('${auction.location} • ${auction.condition}'),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(24),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('current_bid'.tr, style: Theme.of(context).textTheme.labelLarge),
                          const SizedBox(height: 8),
                          Text(
                            controller.formatService.currency(auction.currentBid),
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              AuctionTimer(endTime: auction.endTime),
                              const SizedBox(width: 12),
                              Chip(label: Text('${'watchers'.tr}: ${auction.watchers}')),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Chip(label: Text('${'seller'.tr}: ${auction.sellerId}')),
                              const SizedBox(width: 12),
                              Chip(label: Text('${'rating'.tr}: ${auction.avgRating.toStringAsFixed(1)}★')),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(auction.description),
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: [
                              _InfoChip(label: 'start_price'.tr, value: controller.formatService.currency(auction.startPrice)),
                              if (auction.buyNowPrice != null)
                                _InfoChip(
                                  label: 'buy_now_price'.tr,
                                  value: controller.formatService.currency(auction.buyNowPrice!),
                                ),
                              _InfoChip(label: 'location'.tr, value: auction.location),
                              _InfoChip(label: 'category'.tr, value: auction.category),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: FilledButton(
                                  onPressed: () => controller.placeBid('u_01', auction.currentBid + 10),
                                  child: Text('place_bid'.tr),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: FilledButton.tonal(
                                  onPressed: () {},
                                  child: Text('buy_now'.tr),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {},
                              child: Text('report_issue'.tr),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    SectionHeader(titleKey: 'bid_history'),
                    const SizedBox(height: 12),
                    Obx(() {
                      final bids = controller.bids;
                      if (bids.isEmpty) {
                        return Center(child: Text('no_bids_yet'.tr));
                      }
                      return GlassCard(
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: bids.length,
                          separatorBuilder: (_, __) => const Divider(),
                          itemBuilder: (context, index) {
                            final Bid bid = bids[index];
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(controller.formatService.currency(bid.amount)),
                              subtitle: Text(controller.formatService.dateTimeShort(bid.time)),
                              trailing: Text(bid.userId),
                            );
                          },
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text('$label: $value'),
    );
  }
}
