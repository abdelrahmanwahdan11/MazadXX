import 'package:flutter/material.dart';

class M3SearchBar extends StatelessWidget {
  const M3SearchBar({
    super.key,
    required this.hintText,
    required this.onChanged,
    this.onSubmitted,
    this.controller,
    this.leading,
  });

  final String hintText;
  final ValueChanged<String> onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextEditingController? controller;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        prefixIcon: leading ?? const Icon(Icons.search),
        hintText: hintText,
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.9),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
