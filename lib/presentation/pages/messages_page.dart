import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../application/services/format_service.dart';
import '../../core/routes/app_routes.dart';
import '../controllers/messages_controller.dart';
import '../widgets/glass_card.dart';

class MessagesPage extends GetView<MessagesController> {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final formatService = Get.find<FormatService>();
    return Scaffold(
      appBar: AppBar(title: Text('messages'.tr)),
      body: SafeArea(
        child: Obx(() {
          final threads = controller.threads;
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (threads.isEmpty) {
            return Center(child: Text('empty_state'.tr));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: threads.length,
            itemBuilder: (context, index) {
              final thread = threads[index];
              final unread = controller.unreadThreads.contains(thread.id);
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: GlassCard(
                  child: ListTile(
                    title: Text(thread.users.join(', ')),
                    subtitle: Text(thread.lastMessage),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(formatService.dateTimeShort(thread.updatedAt)),
                        if (unread)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.secondary,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text('unread'.tr, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.white)),
                            ),
                          ),
                      ],
                    ),
                    onTap: () => Get.toNamed(AppRoutes.chat.replaceFirst(':id', thread.id)),
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
