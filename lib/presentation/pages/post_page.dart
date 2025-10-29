import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/routes/app_routes.dart';
import '../controllers/post_controller.dart';
import '../widgets/app_shell.dart';
import '../widgets/glass_card.dart';
import '../widgets/m3_segmented_button.dart';

class PostPage extends GetView<PostController> {
  const PostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShell(
      currentRoute: AppRoutes.post,
      child: SafeArea(
        child: Obx(() {
          final steps = _buildSteps(context);
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('post'.tr, style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 16),
                    Obx(
                      () => M3SegmentedButton<String>(
                        segments: {'auction': 'auction'.tr, 'wanted': 'wanted'.tr},
                        selected: controller.mode.value,
                        onChanged: controller.setMode,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Stepper(
                      currentStep: controller.currentStep.value,
                      controlsBuilder: (context, details) {
                        return Row(
                          children: [
                            FilledButton(
                              onPressed: details.onStepContinue,
                              child: Text(controller.currentStep.value == steps.length - 1 ? 'post_preview'.tr : 'next'.tr),
                            ),
                            const SizedBox(width: 12),
                            if (controller.currentStep.value > 0)
                              TextButton(
                                onPressed: details.onStepCancel,
                                child: Text('previous'.tr),
                              ),
                          ],
                        );
                      },
                      onStepContinue: () {
                        if (controller.currentStep.value == steps.length - 1) {
                          controller.togglePreview();
                        } else {
                          controller.nextStep();
                        }
                      },
                      onStepCancel: controller.previousStep,
                      steps: steps,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Obx(() {
                if (!controller.previewMode.value) {
                  return const SizedBox.shrink();
                }
                final form = controller.form;
                return GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('post_preview'.tr, style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 12),
                      Text('${'title'.tr}: ${form['title'] ?? ''}'),
                      Text('${'category'.tr}: ${form['category'] ?? ''}'),
                      Text('${'condition'.tr}: ${form['condition'] ?? ''}'),
                      Text('${'description'.tr}:\n${form['description'] ?? ''}'),
                      Text('${'price'.tr}: ${form['price'] ?? ''}'),
                      if (controller.mode.value == 'auction')
                        Text('${'reserve_price'.tr}: ${form['reserve'] ?? ''}')
                      else
                        Text('${'target_price'.tr}: ${form['target'] ?? ''}'),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: controller.submit,
                        child: Text('submit'.tr),
                      ),
                    ],
                  ),
                );
              }),
            ],
          );
        }),
      ),
    );
  }

  List<Step> _buildSteps(BuildContext context) {
    return [
      Step(
        title: Text('post_step_photos'.tr),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('post_step_photos_hint'.tr),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: List.generate(
                3,
                (index) => Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.4)),
                  ),
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.add_a_photo_outlined),
                  ),
                ),
              ),
            ),
          ],
        ),
        isActive: controller.currentStep.value >= 0,
      ),
      Step(
        title: Text('post_step_details'.tr),
        content: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'title'.tr),
              onChanged: (value) => controller.updateField('title', value),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(labelText: 'category'.tr),
              onChanged: (value) => controller.updateField('category', value),
            ),
          ],
        ),
        isActive: controller.currentStep.value >= 1,
      ),
      Step(
        title: Text('post_step_condition'.tr),
        content: Column(
          children: [
            DropdownButtonFormField<String>(
              items: ['new', 'excellent', 'good', 'fair']
                  .map((value) => DropdownMenuItem<String>(value: value, child: Text(value.tr)))
                  .toList(),
              onChanged: (value) => controller.updateField('condition', value),
              decoration: InputDecoration(labelText: 'condition'.tr),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(labelText: 'location'.tr),
              onChanged: (value) => controller.updateField('location', value),
            ),
          ],
        ),
        isActive: controller.currentStep.value >= 2,
      ),
      Step(
        title: Text('post_step_description'.tr),
        content: TextField(
          decoration: InputDecoration(labelText: 'description'.tr),
          maxLines: 4,
          onChanged: (value) => controller.updateField('description', value),
        ),
        isActive: controller.currentStep.value >= 3,
      ),
      Step(
        title: Text('post_step_pricing'.tr),
        content: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'price'.tr),
              keyboardType: TextInputType.number,
              onChanged: (value) => controller.updateField('price', value),
            ),
            const SizedBox(height: 12),
            Obx(() {
              if (controller.mode.value == 'auction') {
                return TextField(
                  decoration: InputDecoration(labelText: 'reserve_price'.tr),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => controller.updateField('reserve', value),
                );
              }
              return TextField(
                decoration: InputDecoration(labelText: 'target_price'.tr),
                keyboardType: TextInputType.number,
                onChanged: (value) => controller.updateField('target', value),
              );
            }),
          ],
        ),
        isActive: controller.currentStep.value >= 4,
      ),
    ];
  }
}
