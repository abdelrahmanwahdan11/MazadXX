import '../../domain/entities/offer.dart';
import '../../domain/entities/wanted.dart';
import 'offer_model.dart';

class WantedItem extends Wanted {
  const WantedItem({
    required super.id,
    required super.title,
    required super.category,
    required super.images,
    required super.specs,
    required super.targetPrice,
    required super.location,
    required super.requesterId,
    required super.offers,
  });

  factory WantedItem.fromJson(Map<String, dynamic> json) => WantedItem(
        id: json['id'] as String,
        title: json['title'] as String,
        category: json['category'] as String,
        images: List<String>.from(json['images'] as List<dynamic>? ?? <String>[]),
        specs: json['specs'] as String? ?? '',
        targetPrice: (json['target_price'] as num?)?.toDouble() ?? 0,
        location: json['location'] as String? ?? '',
        requesterId: json['requester_id'] as String,
        offers: (json['offers'] as List<dynamic>? ?? [])
            .map((e) => OfferModel.fromJson(e as Map<String, dynamic>) as Offer)
            .toList(),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'title': title,
        'category': category,
        'images': images,
        'specs': specs,
        'target_price': targetPrice,
        'location': location,
        'requester_id': requesterId,
        'offers': offers.map((Offer e) {
          if (e is OfferModel) {
            return e.toJson();
          }
          return <String, dynamic>{
            'id': e.id,
            'wanted_id': e.wantedId,
            'user_id': e.userId,
            'amount': e.amount,
            'message': e.message,
            'time': e.time.toIso8601String(),
          };
        }).toList(),
      };
}
