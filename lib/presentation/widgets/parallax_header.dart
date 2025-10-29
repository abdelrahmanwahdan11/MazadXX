import 'package:flutter/material.dart';

class ParallaxHeader extends StatelessWidget {
  const ParallaxHeader({
    super.key,
    this.image,
    required this.title,
    this.subtitle,
  });

  final String? image;
  final Widget title;
  final Widget? subtitle;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            if (image == null || image!.isEmpty)
              const _HeaderPlaceholder()
            else
              Image.asset(
                image!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const _HeaderPlaceholder(),
              ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
            Positioned(
              left: 24,
              right: 24,
              bottom: 48,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DefaultTextStyle.merge(
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: Colors.white),
                    child: title,
                  ),
                  if (subtitle != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: DefaultTextStyle.merge(
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white70),
                        child: subtitle!,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderPlaceholder extends StatelessWidget {
  const _HeaderPlaceholder();

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
        child: Icon(Icons.image_outlined, color: Colors.white, size: 72),
      ),
    );
  }
}
