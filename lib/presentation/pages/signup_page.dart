import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../widgets/glass_card.dart';

class SignupPage extends GetView<AuthController> {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: GlassCard(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('signup'.tr, style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(labelText: 'name'.tr),
                ),
                const SizedBox(height: 12),
                TextField(
                  decoration: InputDecoration(labelText: 'email'.tr),
                  onChanged: controller.updateEmail,
                ),
                const SizedBox(height: 12),
                TextField(
                  decoration: InputDecoration(labelText: 'password'.tr),
                  obscureText: true,
                  onChanged: controller.updatePassword,
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: controller.signup,
                  child: Text('create_account'.tr),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => Get.offNamed('/auth/login'),
                  child: Text('have_account'.tr),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
