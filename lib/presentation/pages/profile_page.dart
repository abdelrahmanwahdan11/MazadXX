import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/profile_controller.dart';
import '../widgets/glass_card.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  static const _userOptions = ['u_01', 'u_02', 'u_05', 'u_07'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('profile'.tr)),
      body: SafeArea(
        child: Obx(() {
          final user = controller.user.value;
          if (user == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              GlassCard(
                child: Row(
                  children: [
                    _ProfileAvatar(name: user.name, assetPath: user.avatar),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user.name, style: Theme.of(context).textTheme.headlineSmall),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.amber.shade600),
                              const SizedBox(width: 4),
                              Text('${user.rating.toStringAsFixed(1)} / 5'),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 12,
                            children: user.stats.entries
                                .map((entry) => Chip(label: Text('${entry.key.tr}: ${entry.value}')))
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                    DropdownButton<String>(
                      value: controller.userId.value,
                      onChanged: (value) {
                        if (value != null) {
                          controller.switchUser(value);
                        }
                      },
                      items: _userOptions
                          .map((id) => DropdownMenuItem<String>(value: id, child: Text('${'user'.tr} $id')))
                          .toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('my_auctions'.tr, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 12),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text('wins'.tr),
                      trailing: Text('${user.stats['wins'] ?? 0}'),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text('bids_today'.tr),
                      trailing: Text('${user.stats['bids'] ?? 0}'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('my_wanted'.tr, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 12),
                    Text('wanted_insight'.tr),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('reviews'.tr, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 12),
                    Text('reviews_summary'.trParams({'rating': user.rating.toStringAsFixed(1)})),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({required this.name, required this.assetPath});

  final String name;
  final String assetPath;

  @override
  Widget build(BuildContext context) {
    final initials = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((segment) => segment.isNotEmpty)
        .take(2)
        .map((segment) => segment.substring(0, 1).toUpperCase())
        .join();

    final placeholder = _AvatarFallback(initials: initials);

    if (assetPath.trim().isEmpty) {
      return placeholder;
    }

    return Container(
      width: 72,
      height: 72,
      decoration: const BoxDecoration(shape: BoxShape.circle),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        assetPath,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => placeholder,
      ),
    );
  }
}

class _AvatarFallback extends StatelessWidget {
  const _AvatarFallback({required this.initials});

  final String initials;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 72,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Color(0xFF1FA2FF), Color(0xFF12D8FA), Color(0xFFA6FFCB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Text(
        initials,
        style: Theme.of(context)
            .textTheme
            .headlineSmall
            ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}
