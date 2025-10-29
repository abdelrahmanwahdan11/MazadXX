import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../application/services/format_service.dart';
import '../controllers/notifications_controller.dart';
import '../widgets/glass_card.dart';

class NotificationsPage extends GetView<NotificationsController> {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final formatService = Get.find<FormatService>();
    return Scaffold(
      appBar: AppBar(
        title: Text('notifications'.tr),
        actions: [
          TextButton(
            onPressed: controller.clearAll,
            child: Text('clear_all'.tr),
          ),
        ],
      ),
      body: SafeArea(
        child: Obx(() {
          final items = controller.notifications;
          if (items.isEmpty) {
            return Center(child: Text('no_notifications'.tr));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: GlassCard(
                  child: ListTile(
                    title: Text(item['label'].toString().tr),
                    subtitle: Text(formatService.dateTimeShort(item['time'] as DateTime)),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
