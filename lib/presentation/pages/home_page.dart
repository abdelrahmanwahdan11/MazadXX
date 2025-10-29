import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/routes/app_routes.dart';
import '../controllers/home_controller.dart';
import '../widgets/app_shell.dart';
import '../widgets/auction_card.dart';
import '../widgets/section_header.dart';
import '../widgets/skeleton.dart';
import '../widgets/wanted_card.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShell(
      currentRoute: AppRoutes.auctions,
      child: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: Skeleton(height: 180));
          }
          return Scrollbar.adaptive(
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                  sliver: SliverToBoxAdapter(child: _buildHero(context)),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  sliver: SliverToBoxAdapter(
                    child: _QuickLinks(
                      onSelect: (route) => Get.offAllNamed(route),
                    ),
                  ),
                ),
                _auctionSection(
                  context,
                  title: 'ending_soon',
                  items: controller.endingSoon,
                ),
                _auctionSection(
                  context,
                  title: 'new_arrivals',
                  items: controller.newArrivals,
                ),
                _auctionSection(
                  context,
                  title: 'popular',
                  items: controller.popular,
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  sliver: SliverToBoxAdapter(
                    child: SectionHeader(
                      titleKey: 'wanted',
                      onViewAll: () => Get.offAllNamed(AppRoutes.wanted),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 260,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.spotlightWanted.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 16),
                      itemBuilder: (context, index) {
                        final item = controller.spotlightWanted[index];
                        return SizedBox(
                          width: 280,
                          child: WantedCard(
                            item: item,
                            formatService: controller.formatService,
                            onOffer: () => Get.toNamed('${AppRoutes.wanted}/${item.id}'),
                            onSave: () {},
                            onInfo: () => Get.toNamed('${AppRoutes.wanted}/${item.id}'),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildHero(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: const [Color(0xFF1FA2FF), Color(0xFF12D8FA), Color(0xFFA6FFCB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('home_hero_title'.tr, style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: Colors.white)),
          const SizedBox(height: 12),
          Text('home_hero_subtitle'.tr, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white70)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            children: controller.categories
                .take(4)
                .map((category) => Chip(
                      backgroundColor: Colors.white.withOpacity(0.2),
                      label: Text(category.name),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  SliverPadding _auctionSection(BuildContext context, {required String title, required List<Auction> items}) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(
              titleKey: title,
              onViewAll: () => Get.offAllNamed(AppRoutes.auctions),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 320,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return SizedBox(
                    width: 260,
                    child: AuctionCard(
                      item: item,
                      formatService: controller.formatService,
                      onBid: () => Get.toNamed('${AppRoutes.auctionDetails.replaceFirst(':id', item.id)}'),
                      onWatch: () {},
                      onInfo: () => Get.toNamed('${AppRoutes.auctionDetails.replaceFirst(':id', item.id)}'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickLinks extends StatelessWidget {
  const _QuickLinks({required this.onSelect});

  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      children: [
        _link(context, 'auctions', AppRoutes.auctions),
        _link(context, 'wanted', AppRoutes.wanted),
        _link(context, 'trending', AppRoutes.search),
      ],
    );
  }

  Widget _link(BuildContext context, String key, String route) {
    return ActionChip(
      label: Text(key.tr),
      onPressed: () => onSelect(route),
    );
  }
}
