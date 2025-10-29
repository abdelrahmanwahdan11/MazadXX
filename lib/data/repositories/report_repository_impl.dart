import '../../domain/entities/entities.dart';
import '../../domain/repositories/report_repository.dart';
import '../models/report_model.dart';

class ReportRepositoryImpl implements ReportRepository {
  ReportRepositoryImpl();

  final List<ReportModel> _reports = <ReportModel>[
    ReportModel(
      id: 'r_01',
      entity: 'auction',
      entityId: 'a_1001',
      reason: 'suspected counterfeit',
      date: DateTime.now().subtract(const Duration(days: 1)),
      status: 'pending',
    ),
    ReportModel(
      id: 'r_02',
      entity: 'wanted',
      entityId: 'w_2002',
      reason: 'spam content',
      date: DateTime.now().subtract(const Duration(days: 2)),
      status: 'open',
    ),
  ];

  @override
  Future<List<Report>> fetchReports() async {
    _reports.sort((ReportModel a, ReportModel b) => b.date.compareTo(a.date));
    return List<Report>.unmodifiable(_reports);
  }

  @override
  Future<void> updateStatus(String id, String status) async {
    final index = _reports.indexWhere((ReportModel element) => element.id == id);
    if (index >= 0) {
      final report = _reports[index];
      _reports[index] = ReportModel(
        id: report.id,
        entity: report.entity,
        entityId: report.entityId,
        reason: report.reason,
        date: report.date,
        status: status,
      );
    }
  }
}
