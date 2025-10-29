import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../widgets/glass_card.dart';

class LoginPage extends GetView<AuthController> {
  const LoginPage({super.key});

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
                Text('login'.tr, style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 16),
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
                const SizedBox(height: 12),
                Row(
                  children: [
                    Obx(
                      () => Checkbox(
                        value: controller.rememberMe.value,
                        onChanged: (value) => controller.rememberMe.value = value ?? false,
                      ),
                    ),
                    Text('remember_me'.tr),
                  ],
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: controller.login,
                  child: Text('login'.tr),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => Get.toNamed('/auth/signup'),
                  child: Text('create_account'.tr),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
