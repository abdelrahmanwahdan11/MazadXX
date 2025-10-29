import 'package:get/get.dart';

import '../../domain/entities/entities.dart';
import '../../domain/repositories/report_repository.dart';

class ModerationController extends GetxController {
  ModerationController(this.repository);

  final ReportRepository repository;

  final RxList<Report> reports = <Report>[].obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    reports.assignAll(await repository.fetchReports());
  }

  Future<void> updateStatus(String id, String status) async {
    await repository.updateStatus(id, status);
    await load();
  }
}
