import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class Skeleton extends StatelessWidget {
  const Skeleton({super.key, this.height = 16, this.width = double.infinity, this.radius = 12});

  final double height;
  final double width;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final baseColor = Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5);
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(radius),
      ),
    ).animate(onPlay: (controller) => controller.repeat())
        .fadeIn(duration: 240.ms)
        .then(delay: 240.ms)
        .fadeOut(duration: 240.ms);
  }
}
