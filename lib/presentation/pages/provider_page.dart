import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/provider_controller.dart';
import '../widgets/glass_card.dart';

class ProviderPage extends StatefulWidget {
  const ProviderPage({super.key});

  @override
  State<ProviderPage> createState() => _ProviderPageState();
}

class _ProviderPageState extends State<ProviderPage> {
  final ProviderController controller = Get.find<ProviderController>();
  final TextEditingController itemController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();

  @override
  void dispose() {
    itemController.dispose();
    categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('provider'.tr)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('managed_items'.tr, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  TextField(
                    controller: itemController,
                    decoration: InputDecoration(labelText: 'name'.tr),
                  ),
                  const SizedBox(height: 8),
                  FilledButton(
                    onPressed: () async {
                      final label = itemController.text.trim();
                      if (label.isEmpty) return;
                      await controller.addItem(<String, dynamic>{
                        'id': 'item_${DateTime.now().millisecondsSinceEpoch}',
                        'name': label,
                      });
                      itemController.clear();
                    },
                    child: Text('add_item'.tr),
                  ),
                  const SizedBox(height: 16),
                  Obx(() {
                    final items = controller.managedItems;
                    if (items.isEmpty) {
                      return Text('no_items'.tr);
                    }
                    return Column(
                      children: items
                          .map(
                            (item) => ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(item['name']?.toString() ?? ''),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete_outline),
                                onPressed: () => controller.removeItem(item['id']?.toString() ?? ''),
                              ),
                            ),
                          )
                          .toList(),
                    );
                  }),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => _showExport(context, controller.managedItems.toList()),
                      child: Text('export'.tr),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('managed_categories'.tr, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  TextField(
                    controller: categoryController,
                    decoration: InputDecoration(labelText: 'name'.tr),
                  ),
                  const SizedBox(height: 8),
                  FilledButton(
                    onPressed: () async {
                      final label = categoryController.text.trim();
                      if (label.isEmpty) return;
                      await controller.addCategory(<String, dynamic>{
                        'id': 'cat_${DateTime.now().millisecondsSinceEpoch}',
                        'name': label,
                      });
                      categoryController.clear();
                    },
                    child: Text('add_category'.tr),
                  ),
                  const SizedBox(height: 16),
                  Obx(() {
                    final categories = controller.managedCategories;
                    if (categories.isEmpty) {
                      return Text('no_categories'.tr);
                    }
                    return Column(
                      children: categories
                          .map(
                            (category) => ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(category['name']?.toString() ?? ''),
                            ),
                          )
                          .toList(),
                    );
                  }),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => _showExport(context, controller.managedCategories.toList()),
                      child: Text('export'.tr),
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

  Future<void> _showExport(BuildContext context, List<Map<String, dynamic>> data) async {
    final json = const JsonEncoder.withIndent('  ').convert(data);
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('export'.tr),
        content: SingleChildScrollView(child: Text(json)),
        actions: [
          TextButton(onPressed: () => Get.back<void>(), child: Text('close'.tr)),
        ],
      ),
    );
  }
}
