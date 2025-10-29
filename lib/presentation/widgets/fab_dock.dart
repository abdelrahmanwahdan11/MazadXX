import 'package:flutter/material.dart';

class FabDock extends StatelessWidget {
  const FabDock({super.key, required this.buttons});

  final List<Widget> buttons;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(color: Color(0x14000000), blurRadius: 24, offset: Offset(0, 12)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: buttons
              .map(
                (Widget e) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: e,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
