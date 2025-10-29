import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({super.key, required this.titleKey});

  final String titleKey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(titleKey.tr)),
      body: Center(
        child: Text('coming_soon'.trParams({'feature': titleKey.tr})),
      ),
    );
  }
}
