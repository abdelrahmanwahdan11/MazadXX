import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../application/services/format_service.dart';
import '../controllers/moderation_controller.dart';
import '../widgets/glass_card.dart';

class ModerationPage extends GetView<ModerationController> {
  const ModerationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final formatService = Get.find<FormatService>();
    return Scaffold(
      appBar: AppBar(title: Text('moderation'.tr)),
      body: SafeArea(
        child: Obx(() {
          final reports = controller.reports;
          if (reports.isEmpty) {
            return Center(child: Text('no_reports'.tr));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: reports.length,
            itemBuilder: (context, index) {
              final report = reports[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${report.entity} • ${report.entityId}', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 4),
                      Text(report.reason),
                      const SizedBox(height: 4),
                      Text('${'status'.tr}: ${report.status}'),
                      Text(formatService.dateTimeShort(report.date)),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          FilledButton(
                            onPressed: () => controller.updateStatus(report.id, 'approved'),
                            child: Text('approve'.tr),
                          ),
                          const SizedBox(width: 12),
                          OutlinedButton(
                            onPressed: () => controller.updateStatus(report.id, 'rejected'),
                            child: Text('reject'.tr),
                          ),
                        ],
                      ),
                    ],
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
