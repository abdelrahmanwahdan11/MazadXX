import 'offer.dart';

class Wanted {
  const Wanted({
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
