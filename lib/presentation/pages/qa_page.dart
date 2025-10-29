import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/qa_controller.dart';
import '../widgets/glass_card.dart';

class QaPage extends StatefulWidget {
  const QaPage({super.key});

  @override
  State<QaPage> createState() => _QaPageState();
}

class _QaPageState extends State<QaPage> {
  final QaController controller = Get.find<QaController>();
  final TextEditingController linkController = TextEditingController();
  bool showOverlay = false;

  @override
  void dispose() {
    linkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('qa'.tr)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('action_log'.tr, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  ...controller.logs.map((entry) => Text(entry)).toList(),
                ],
              ),
            ),
            const SizedBox(height: 24),
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('missing_keys'.trParams({'count': controller.missingCount.toString()})),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: controller.rebuildIndex,
                    child: Text('rebuild_index'.tr),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('deep_link'.tr, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  TextField(
                    controller: linkController,
                    decoration: InputDecoration(labelText: 'route'.tr),
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () {
                      final route = linkController.text.trim();
                      if (route.isNotEmpty) {
                        Get.toNamed(route);
                      }
                    },
                    child: Text('open'.tr),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            GlassCard(
              child: SwitchListTile(
                title: Text('performance_overlay'.tr),
                value: showOverlay,
                onChanged: (value) {
                  setState(() => showOverlay = value);
                  controller.actionLog.add('perf_overlay:$value');
                },
              ),
            ),
            const SizedBox(height: 24),
            GlassCard(
              child: TextButton(
                onPressed: () => controller.actionLog.add('qa_export'),
                child: Text('export_diagnostics'.tr),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
