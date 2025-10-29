import 'package:flutter/widgets.dart';

import 'action_log.dart';

class LifecycleHandlers with WidgetsBindingObserver {
  LifecycleHandlers(this.actionLog);

  final ActionLog actionLog;

  void init() {
    WidgetsBinding.instance.addObserver(this);
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    actionLog.add('lifecycle:${state.name}');
  }
}
