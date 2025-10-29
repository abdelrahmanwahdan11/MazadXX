class Bid {
  const Bid({
    required this.id,
    required this.auctionId,
    required this.userId,
    required this.amount,
    required this.time,
  });

  final String id;
  final String auctionId;
  final String userId;
  final double amount;
  final DateTime time;
}
