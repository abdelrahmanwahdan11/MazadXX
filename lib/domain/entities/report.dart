class Report {
  const Report({
    required this.id,
    required this.entity,
    required this.entityId,
    required this.reason,
    required this.date,
    required this.status,
  });

  final String id;
  final String entity;
  final String entityId;
  final String reason;
  final DateTime date;
  final String status;
}
