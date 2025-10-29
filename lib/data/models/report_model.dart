import '../../domain/entities/report.dart';

class ReportModel extends Report {
  const ReportModel({
    required super.id,
    required super.entity,
    required super.entityId,
    required super.reason,
    required super.date,
    required super.status,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) => ReportModel(
        id: json['id'] as String,
        entity: json['entity'] as String,
        entityId: json['entity_id'] as String,
        reason: json['reason'] as String? ?? '',
        date: DateTime.parse(json['date'] as String),
        status: json['status'] as String? ?? 'open',
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'entity': entity,
        'entity_id': entityId,
        'reason': reason,
        'date': date.toIso8601String(),
        'status': status,
      };
}
