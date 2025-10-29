import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../controllers/onboarding_controller.dart';
import '../widgets/glass_card.dart';

class OnboardingPage extends GetView<OnboardingController> {
  const OnboardingPage({super.key});

  static const _slides = [
    ('onboarding_discover', 'onboarding_discover_body', 'assets/images/onboarding/slide1.png'),
    ('onboarding_bid', 'onboarding_bid_body', 'assets/images/onboarding/slide2.png'),
    ('onboarding_secure', 'onboarding_secure_body', 'assets/images/onboarding/slide3.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                itemCount: _slides.length,
                onPageChanged: controller.setPage,
                itemBuilder: (context, index) {
                  final slide = _slides[index];
                  return Padding(
                    padding: const EdgeInsets.all(24),
                    child: GlassCard(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Expanded(
                            child: Image.asset(
                              slide.$3,
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                            ).animate().fadeIn(duration: 400.ms),
                          ),
                          const SizedBox(height: 16),
                          Text(slide.$1.tr, style: Theme.of(context).textTheme.headlineMedium),
                          const SizedBox(height: 12),
                          Text(slide.$2.tr, textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Obx(
                () => Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value: (controller.pageIndex.value + 1) / _slides.length,
                      ),
                    ),
                    const SizedBox(width: 16),
                    FilledButton(
                      onPressed: controller.finish,
                      child: Text(controller.pageIndex.value == _slides.length - 1 ? 'start_now'.tr : 'skip'.tr),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
