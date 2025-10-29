class Offer {
  const Offer({
    required this.id,
    required this.wantedId,
    required this.userId,
    required this.amount,
    required this.message,
    required this.time,
  });

  factory Offer.fromJson(Map<String, dynamic> json) => Offer(
        id: json['id'] as String,
        wantedId: json['wanted_id'] as String,
        userId: json['user_id'] as String,
        amount: (json['amount'] as num).toDouble(),
        message: json['message'] as String? ?? '',
        time: DateTime.parse(json['time'] as String),
      );

  final String id;
  final String wantedId;
  final String userId;
  final double amount;
  final String message;
  final DateTime time;
}
