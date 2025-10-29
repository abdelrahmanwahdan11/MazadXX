import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/categories_controller.dart';
import '../controllers/filters_controller.dart';
import '../widgets/glass_card.dart';

class FiltersPage extends GetView<FiltersController> {
  const FiltersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final categoriesController = Get.find<CategoriesController>();
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1FA2FF), Color(0xFF12D8FA)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.85,
            maxChildSize: 0.95,
            minChildSize: 0.6,
            builder: (context, scrollController) {
              return GlassCard(
                padding: const EdgeInsets.all(24),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('filters'.tr, style: Theme.of(context).textTheme.headlineSmall),
                          IconButton(
                            onPressed: () => Get.back(),
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text('price_range'.tr, style: Theme.of(context).textTheme.titleMedium),
                      Obx(() {
                        final min = controller.minPrice.value;
                        final max = controller.maxPrice.value;
                        return RangeSlider(
                          min: 0,
                          max: 20000,
                          values: RangeValues(min, max),
                          divisions: 200,
                          labels: RangeLabels(min.toStringAsFixed(0), max.toStringAsFixed(0)),
                          onChanged: (value) {
                            controller.minPrice.value = value.start;
                            controller.maxPrice.value = value.end;
                          },
                        );
                      }),
                      const SizedBox(height: 16),
                      Text('category'.tr, style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Obx(() {
                        final selected = controller.categories;
                        final categories = categoriesController.categories;
                        return Wrap(
                          spacing: 12,
                          children: categories
                              .map(
                                (category) => FilterChip(
                                  label: Text(category.name),
                                  selected: selected.contains(category.id),
                                  onSelected: (value) {
                                    if (value) {
                                      selected.add(category.id);
                                    } else {
                                      selected.remove(category.id);
                                    }
                                  },
                                ),
                              )
                              .toList(),
                        );
                      }),
                      const SizedBox(height: 16),
                      Text('condition'.tr, style: Theme.of(context).textTheme.titleMedium),
                      DropdownButtonFormField<String>(
                        value: controller.condition.value.isEmpty ? null : controller.condition.value,
                        items: ['new', 'excellent', 'good', 'fair']
                            .map((value) => DropdownMenuItem<String>(value: value, child: Text(value.tr)))
                            .toList(),
                        onChanged: (value) => controller.condition.value = value ?? '',
                        decoration: InputDecoration(labelText: 'condition'.tr),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        decoration: InputDecoration(labelText: 'location'.tr),
                        onChanged: (value) => controller.location.value = value,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: FilledButton(
                              onPressed: () => Get.back(result: controller.buildFilter()),
                              child: Text('apply'.tr),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                controller.clearFilters();
                              },
                              child: Text('reset'.tr),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('saved_filters'.tr, style: Theme.of(context).textTheme.titleMedium),
                          TextButton(
                            onPressed: () => _showSaveDialog(context),
                            child: Text('save_filter'.tr),
                          ),
                        ],
                      ),
                      Obx(() {
                        final saved = controller.savedFilters;
                        if (saved.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Text('no_saved_filters'.tr),
                          );
                        }
                        return Column(
                          children: saved
                              .map(
                                (filter) => ListTile(
                                  title: Text(filter.label),
                                  subtitle: Text(filter.payload.toString()),
                                  trailing: Wrap(
                                    spacing: 8,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.play_arrow),
                                        onPressed: () => controller.applySaved(filter),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete_outline),
                                        onPressed: () => controller.deleteFilter(filter.id),
                                      ),
                                    ],
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
            },
          ),
        ],
      ),
    );
  }

  Future<void> _showSaveDialog(BuildContext context) async {
    final labelController = TextEditingController();
    final controller = Get.find<FiltersController>();
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('save_filter'.tr),
          content: TextField(
            controller: labelController,
            decoration: InputDecoration(labelText: 'enter_label'.tr),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back<void>(),
              child: Text('cancel'.tr),
            ),
            FilledButton(
              onPressed: () {
                final label = labelController.text.trim();
                if (label.isNotEmpty) {
                  controller.saveCurrent(label);
                }
                Get.back<void>();
              },
              child: Text('save'.tr),
            ),
          ],
        );
      },
    );
  }
}
