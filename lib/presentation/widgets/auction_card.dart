import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../application/services/format_service.dart';
import '../../domain/entities/entities.dart';
import 'auction_timer.dart';
import 'glass_card.dart';

class AuctionCard extends StatelessWidget {
  const AuctionCard({
    super.key,
    required this.item,
    required this.formatService,
    required this.onBid,
    required this.onWatch,
    this.onInfo,
    this.isWatchlisted = false,
  });

  final Auction item;
  final FormatService formatService;
  final VoidCallback onBid;
  final VoidCallback onWatch;
  final VoidCallback? onInfo;
  final bool isWatchlisted;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(28);
    final card = GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 4 / 3,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (item.images.isEmpty)
                    const _AuctionImagePlaceholder()
                  else
                    Image.asset(
                      item.images.first,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const _AuctionImagePlaceholder(),
                    ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: IconButton(
                      icon: Icon(isWatchlisted ? Icons.bookmark : Icons.bookmark_border),
                      color: Colors.white,
                      onPressed: onWatch,
                      mouseCursor: MaterialStateMouseCursor.clickable,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(item.title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 4),
          Text('${item.location} • ${item.condition}', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(formatService.currency(item.currentBid), style: Theme.of(context).textTheme.headlineSmall),
              AuctionTimer(endTime: item.endTime),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: FilledButton(onPressed: onBid, child: Text('place_bid'.tr)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(onPressed: onWatch, child: Text(isWatchlisted ? 'watching'.tr : 'watchlist'.tr)),
              ),
            ],
          ),
        ],
      ),
    );

    return MouseRegion(
      cursor: onInfo != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: Material(
        color: Colors.transparent,
        borderRadius: borderRadius,
        child: InkWell(
          borderRadius: borderRadius,
          hoverColor: Theme.of(context).colorScheme.primary.withOpacity(0.08),
          splashColor: Theme.of(context).colorScheme.primary.withOpacity(0.12),
          onTap: onInfo,
          child: card,
        ),
      ),
    );
  }
}

class _AuctionImagePlaceholder extends StatelessWidget {
  const _AuctionImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1FA2FF), Color(0xFF12D8FA), Color(0xFFA6FFCB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Center(
        child: Icon(Icons.local_offer, color: Colors.white, size: 48),
      ),
    );
  }
}
