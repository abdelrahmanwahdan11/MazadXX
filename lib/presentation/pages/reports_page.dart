import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/reports_controller.dart';
import '../widgets/glass_card.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  final ReportsController controller = Get.find<ReportsController>();
  final TextEditingController reasonController = TextEditingController();
  final TextEditingController entityController = TextEditingController();

  @override
  void dispose() {
    reasonController.dispose();
    entityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('reports'.tr)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('submit_report'.tr, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  TextField(
                    controller: entityController,
                    decoration: InputDecoration(labelText: 'entity'.tr),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: reasonController,
                    decoration: InputDecoration(labelText: 'reason'.tr),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () async {
                      final entity = entityController.text.trim();
                      final reason = reasonController.text.trim();
                      if (entity.isEmpty || reason.isEmpty) return;
                      await controller.submit(<String, dynamic>{
                        'id': 'report_${DateTime.now().millisecondsSinceEpoch}',
                        'entity': entity,
                        'reason': reason,
                        'date': DateTime.now().toIso8601String(),
                        'status': 'submitted',
                      });
                      entityController.clear();
                      reasonController.clear();
                    },
                    child: Text('submit'.tr),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Obx(() {
              final reports = controller.reports;
              if (reports.isEmpty) {
                return Center(child: Text('no_reports_submitted'.tr));
              }
              return Column(
                children: reports
                    .map(
                      (report) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: GlassCard(
                          child: ListTile(
                            title: Text(report['entity']?.toString() ?? ''),
                            subtitle: Text(report['reason']?.toString() ?? ''),
                            trailing: Text(report['status']?.toString() ?? ''),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              );
            }),
          ],
        ),
      ),
    );
  }
}
