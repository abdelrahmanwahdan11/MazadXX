import 'package:get/get.dart';

import '../../application/services/action_log.dart';
import '../../application/services/i18n_audit_service.dart';
import '../../application/services/index_service.dart';

class QaController extends GetxController {
  QaController({
    required this.actionLog,
    required this.auditService,
    required this.indexService,
  });

  final ActionLog actionLog;
  final I18nAuditService auditService;
  final IndexService indexService;

  List<String> get logs => actionLog.entries;
  int get missingCount => auditService.missingCount;

  void rebuildIndex() {
    actionLog.add('qa_reindex');
  }
}
