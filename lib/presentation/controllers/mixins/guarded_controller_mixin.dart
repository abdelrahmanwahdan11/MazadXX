import 'dart:async';

mixin GuardedControllerMixin {
  final List<Timer> _timers = <Timer>[];

  void trackTimer(Timer timer) {
    _timers.add(timer);
  }

  void cancelTimers() {
    for (final timer in _timers) {
      timer.cancel();
    }
    _timers.clear();
  }
}
