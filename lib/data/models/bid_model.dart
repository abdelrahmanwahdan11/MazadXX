import '../../domain/entities/bid.dart';

class BidModel extends Bid {
  const BidModel({
    required super.id,
    required super.auctionId,
    required super.userId,
    required super.amount,
    required super.time,
  });

  factory BidModel.fromJson(Map<String, dynamic> json) => BidModel(
        id: json['id'] as String,
        auctionId: json['auction_id'] as String,
        userId: json['user_id'] as String,
        amount: (json['amount'] as num).toDouble(),
        time: DateTime.parse(json['time'] as String),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'auction_id': auctionId,
        'user_id': userId,
        'amount': amount,
        'time': time.toIso8601String(),
      };
}
