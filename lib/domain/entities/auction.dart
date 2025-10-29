import 'review.dart';

class Auction {
  const Auction({
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
