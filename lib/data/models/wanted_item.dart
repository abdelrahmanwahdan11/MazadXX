import 'offer.dart';

class WantedItem {
  const WantedItem({
    required this.id,
    required this.title,
    required this.category,
    required this.images,
    required this.specs,
    required this.targetPrice,
    required this.location,
    required this.requesterId,
    required this.offers,
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
            .map((e) => Offer.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  final String id;
  final String title;
  final String category;
  final List<String> images;
  final String specs;
  final double targetPrice;
  final String location;
  final String requesterId;
  final List<Offer> offers;
}
