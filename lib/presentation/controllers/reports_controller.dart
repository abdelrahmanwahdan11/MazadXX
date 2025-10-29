import 'package:get/get.dart';

import '../../application/services/local_store.dart';

class ReportsController extends GetxController {
  ReportsController(this.localStore);

  final LocalStore localStore;

  final RxList<Map<String, dynamic>> reports = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  void _load() {
    reports.assignAll(localStore.readList('user_reports').whereType<Map<String, dynamic>>());
  }

  Future<void> submit(Map<String, dynamic> report) async {
    reports.add(report);
    await localStore.writeList('user_reports', reports.toList());
  }
}
