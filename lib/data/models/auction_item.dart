import 'review.dart';

class AuctionItem {
  const AuctionItem({
    required this.id,
    required this.title,
    required this.category,
    required this.images,
    required this.condition,
    required this.description,
    required this.location,
    required this.startPrice,
    required this.buyNowPrice,
    required this.currentBid,
    required this.endTime,
    required this.sellerId,
    required this.watchers,
    required this.reviews,
    required this.avgRating,
  });

  factory AuctionItem.fromJson(Map<String, dynamic> json) => AuctionItem(
        id: json['id'] as String,
        title: json['title'] as String,
        category: json['category'] as String,
        images: List<String>.from(json['images'] as List<dynamic>? ?? <String>[]),
        condition: json['condition'] as String? ?? '',
        description: json['description'] as String? ?? '',
        location: json['location'] as String? ?? '',
        startPrice: (json['start_price'] as num?)?.toDouble() ?? 0,
        buyNowPrice: (json['buy_now_price'] as num?)?.toDouble(),
        currentBid: (json['current_bid'] as num?)?.toDouble() ?? 0,
        endTime: DateTime.parse(json['end_time'] as String),
        sellerId: json['seller_id'] as String,
        watchers: (json['watchers'] as num?)?.toInt() ?? 0,
        reviews: (json['reviews'] as List<dynamic>? ?? [])
            .map((e) => Review.fromJson(e as Map<String, dynamic>))
            .toList(),
        avgRating: (json['avg_rating'] as num?)?.toDouble() ?? 0,
      );

  final String id;
  final String title;
  final String category;
  final List<String> images;
  final String condition;
  final String description;
  final String location;
  final double startPrice;
  final double? buyNowPrice;
  final double currentBid;
  final DateTime endTime;
  final String sellerId;
  final int watchers;
  final List<Review> reviews;
  final double avgRating;
}
