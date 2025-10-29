import '../entities/entities.dart';

abstract class ReportRepository {
  Future<List<Report>> fetchReports();
  Future<void> updateStatus(String id, String status);
}
