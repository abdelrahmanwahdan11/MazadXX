import '../../domain/entities/offer.dart';

class OfferModel extends Offer {
  const OfferModel({
    required super.id,
    required super.wantedId,
    required super.userId,
    required super.amount,
    required super.message,
    required super.time,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) => OfferModel(
        id: json['id'] as String,
        wantedId: json['wanted_id'] as String,
        userId: json['user_id'] as String,
        amount: (json['amount'] as num).toDouble(),
        message: json['message'] as String? ?? '',
        time: DateTime.parse(json['time'] as String),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'wanted_id': wantedId,
        'user_id': userId,
        'amount': amount,
        'message': message,
        'time': time.toIso8601String(),
      };
}
