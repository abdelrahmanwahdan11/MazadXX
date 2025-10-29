import 'package:get/get.dart';

import '../../application/services/action_log.dart';

class NotificationsController extends GetxController {
  NotificationsController(this.actionLog);

  final ActionLog actionLog;

  final RxList<Map<String, dynamic>> notifications = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    _seed();
  }

  void _seed() {
    notifications.assignAll(<Map<String, dynamic>>[
      <String, dynamic>{'label': 'notification_bid_outbid', 'time': DateTime.now().subtract(const Duration(minutes: 10))},
      <String, dynamic>{'label': 'notification_message_new', 'time': DateTime.now().subtract(const Duration(hours: 1))},
      <String, dynamic>{'label': 'notification_win', 'time': DateTime.now().subtract(const Duration(days: 1))},
    ]);
  }

  void clearAll() {
    notifications.clear();
    actionLog.add('notifications_clear');
  }
}
