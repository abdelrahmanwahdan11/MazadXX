import '../../data/models/auction_item.dart';
import '../../data/models/wanted_item.dart';

class IndexService {
  IndexService();

  final Map<String, double> _weights = const {
    'title': 3,
    'category': 2,
    'seller_name': 1.5,
    'requester_name': 1.5,
    'description': 1,
  };

  List<String> searchAuctions(List<AuctionItem> items, String query) {
    if (query.isEmpty) return items.map((e) => e.id).toList();
    final lower = query.toLowerCase();
    final entries = <MapEntry<String, double>>[];
    for (final item in items) {
      var score = 0.0;
      if (item.title.toLowerCase().contains(lower)) {
        score += _weights['title']!;
      }
      if (item.category.toLowerCase().contains(lower)) {
        score += _weights['category']!;
      }
      if (item.description.toLowerCase().contains(lower)) {
        score += _weights['description']!;
      }
      if (score > 0) {
        entries.add(MapEntry(item.id, score));
      }
    }
    entries.sort((a, b) => b.value.compareTo(a.value));
    return entries.map((e) => e.key).toList();
  }

  List<String> searchWanted(List<WantedItem> items, String query) {
    if (query.isEmpty) return items.map((e) => e.id).toList();
    final lower = query.toLowerCase();
    final entries = <MapEntry<String, double>>[];
    for (final item in items) {
      var score = 0.0;
      if (item.title.toLowerCase().contains(lower)) {
        score += _weights['title']!;
      }
      if (item.category.toLowerCase().contains(lower)) {
        score += _weights['category']!;
      }
      if (item.specs.toLowerCase().contains(lower)) {
        score += _weights['description']!;
      }
      if (score > 0) {
        entries.add(MapEntry(item.id, score));
      }
    }
    entries.sort((a, b) => b.value.compareTo(a.value));
    return entries.map((e) => e.key).toList();
  }
}
