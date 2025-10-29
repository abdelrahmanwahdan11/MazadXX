import '../../domain/entities/auction.dart';
import '../../domain/entities/review.dart';
import 'review_model.dart';

class AuctionItem extends Auction {
  const AuctionItem({
    required super.id,
    required super.title,
    required super.category,
    required super.images,
    required super.condition,
    required super.description,
    required super.location,
    required super.startPrice,
    required super.buyNowPrice,
    required super.currentBid,
    required super.endTime,
    required super.sellerId,
    required super.watchers,
    required super.reviews,
    required super.avgRating,
  });

  factory AuctionItem.fromJson(Map<String, dynamic> json) {
    return AuctionItem(
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
          .map((e) => ReviewModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      avgRating: (json['avg_rating'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'title': title,
        'category': category,
        'images': images,
        'condition': condition,
        'description': description,
        'location': location,
        'start_price': startPrice,
        'buy_now_price': buyNowPrice,
        'current_bid': currentBid,
        'end_time': endTime.toIso8601String(),
        'seller_id': sellerId,
        'watchers': watchers,
        'reviews': reviews.map((Review e) {
          if (e is ReviewModel) {
            return e.toJson();
          }
          return <String, dynamic>{
            'user': e.user,
            'stars': e.stars,
            'text': e.text,
            'date': e.date.toIso8601String(),
          };
        }).toList(),
        'avg_rating': avgRating,
      };

  AuctionItem copyWith({
    String? title,
    List<String>? images,
    String? condition,
    String? description,
    String? location,
    double? startPrice,
    double? buyNowPrice,
    double? currentBid,
    DateTime? endTime,
    String? sellerId,
    int? watchers,
    List<Review>? reviews,
    double? avgRating,
  }) {
    return AuctionItem(
      id: id,
      title: title ?? this.title,
      category: category,
      images: images ?? this.images,
      condition: condition ?? this.condition,
      description: description ?? this.description,
      location: location ?? this.location,
      startPrice: startPrice ?? this.startPrice,
      buyNowPrice: buyNowPrice ?? this.buyNowPrice,
      currentBid: currentBid ?? this.currentBid,
      endTime: endTime ?? this.endTime,
      sellerId: sellerId ?? this.sellerId,
      watchers: watchers ?? this.watchers,
      reviews: reviews ?? this.reviews,
      avgRating: avgRating ?? this.avgRating,
    );
  }
}
