class Offer {
  const Offer({
    required this.id,
    required this.wantedId,
    required this.userId,
    required this.amount,
    required this.message,
    required this.time,
  });

  final String id;
  final String wantedId;
  final String userId;
  final double amount;
  final String message;
  final DateTime time;
}
