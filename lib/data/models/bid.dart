class Bid {
  const Bid({
    required this.id,
    required this.auctionId,
    required this.userId,
    required this.amount,
    required this.time,
  });

  factory Bid.fromJson(Map<String, dynamic> json) => Bid(
        id: json['id'] as String,
        auctionId: json['auction_id'] as String,
        userId: json['user_id'] as String,
        amount: (json['amount'] as num).toDouble(),
        time: DateTime.parse(json['time'] as String),
      );

  final String id;
  final String auctionId;
  final String userId;
  final double amount;
  final DateTime time;
}
