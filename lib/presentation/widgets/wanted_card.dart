import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../application/services/format_service.dart';
import '../../data/models/wanted_item.dart';
import 'glass_card.dart';

class WantedCard extends StatelessWidget {
  const WantedCard({super.key, required this.item, required this.onOffer, required this.onSave});

  final WantedItem item;
  final VoidCallback onOffer;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final format = FormatService();
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item.title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(item.specs, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 12),
          Text('${'target_price'.tr}: ${format.currency(item.targetPrice)}'),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: FilledButton(onPressed: onOffer, child: Text('make_offer'.tr))),
              const SizedBox(width: 12),
              Expanded(child: OutlinedButton(onPressed: onSave, child: Text('save_filter'.tr))),
            ],
          ),
        ],
      ),
    );
  }
}
