import 'dart:async';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../application/services/format_service.dart';

class AuctionTimer extends StatefulWidget {
  const AuctionTimer({super.key, required this.endTime});

  final DateTime endTime;

  @override
  State<AuctionTimer> createState() => _AuctionTimerState();
}

class _AuctionTimerState extends State<AuctionTimer> {
  late Duration remaining;
  Timer? _timer;
  final FormatService formatService = FormatService();

  @override
  void initState() {
    super.initState();
    remaining = widget.endTime.difference(DateTime.now());
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final diff = widget.endTime.difference(DateTime.now());
      if (diff.isNegative) {
        _timer?.cancel();
        setState(() => remaining = Duration.zero);
      } else {
        setState(() => remaining = diff);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final label = remaining.isNegative ? 'ended'.tr : formatService.timeRemaining(remaining);
    return Chip(
      label: Text(label),
    );
  }
}
