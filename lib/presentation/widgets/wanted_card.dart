import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../application/services/format_service.dart';
import '../../domain/entities/entities.dart';
import 'glass_card.dart';

class WantedCard extends StatelessWidget {
  const WantedCard({
    super.key,
    required this.item,
    required this.formatService,
    required this.onOffer,
    required this.onSave,
    this.onInfo,
    this.isSaved = false,
  });

  final Wanted item;
  final FormatService formatService;
  final VoidCallback onOffer;
  final VoidCallback onSave;
  final VoidCallback? onInfo;
  final bool isSaved;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(28);
    final card = GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item.title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 4),
          Text('${item.location} • ${item.category}', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 12),
          Text(
            item.specs,
            style: Theme.of(context).textTheme.bodyMedium,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Text('${'target_price'.tr}: ${formatService.currency(item.targetPrice)}'),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: FilledButton(onPressed: onOffer, child: Text('make_offer'.tr))),
              const SizedBox(width: 12),
              IconButton(
                onPressed: onSave,
                icon: Icon(isSaved ? Icons.favorite : Icons.favorite_border),
                mouseCursor: MaterialStateMouseCursor.clickable,
              ),
            ],
          ),
        ],
      ),
    );

    return MouseRegion(
      cursor: onInfo != null ? MaterialStateMouseCursor.clickable : MouseCursor.defer,
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
