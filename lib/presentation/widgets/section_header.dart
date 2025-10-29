import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.titleKey, this.onViewAll});

  final String titleKey;
  final VoidCallback? onViewAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(titleKey.tr, style: Theme.of(context).textTheme.titleLarge),
        if (onViewAll != null)
          TextButton(
            onPressed: onViewAll,
            child: Text('view_all'.tr),
          ),
      ],
    );
  }
}
