import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../application/services/format_service.dart';
import '../../data/models/auction_item.dart';
import 'auction_timer.dart';
import 'glass_card.dart';

class AuctionCard extends StatelessWidget {
  const AuctionCard({super.key, required this.item, required this.onBid, required this.onWatch});

  final AuctionItem item;
  final VoidCallback onBid;
  final VoidCallback onWatch;

  @override
  Widget build(BuildContext context) {
    final format = FormatService();
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 4 / 3,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Container(
                color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.6),
                alignment: Alignment.center,
                child: Text(item.title, textAlign: TextAlign.center),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(item.title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(format.currency(item.currentBid), style: Theme.of(context).textTheme.titleLarge),
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
                child: OutlinedButton(onPressed: onWatch, child: Text('watchlist'.tr)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
