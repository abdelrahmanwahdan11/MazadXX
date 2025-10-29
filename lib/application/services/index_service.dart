import '../../domain/entities/entities.dart';
import 'synonyms_service.dart';

class IndexService {
  IndexService({SynonymsService? synonymsService})
      : synonymsService = synonymsService ?? const SynonymsService();

  final SynonymsService synonymsService;

  final Map<String, double> _weights = const <String, double>{
    'title': 3,
    'category': 2,
    'seller_name': 1.5,
    'requester_name': 1.5,
    'description': 1,
    'location': 1,
  };

  List<String> searchAuctions(
    List<Auction> items,
    String query, {
    Map<String, User>? users,
    String locale = 'en_US',
  }) {
    if (query.trim().isEmpty) {
      return items.map((Auction e) => e.id).toList(growable: false);
    }
    final expandedTerms = synonymsService.expand(query, locale: locale);
    final entries = <MapEntry<String, double>>[];
    for (final item in items) {
      final sellerName = users?[item.sellerId]?.name.toLowerCase() ?? '';
      final haystacks = <String, double>{
        item.title.toLowerCase(): _weights['title']!,
        item.category.toLowerCase(): _weights['category']!,
        item.description.toLowerCase(): _weights['description']!,
        item.location.toLowerCase(): _weights['location']!,
        sellerName: _weights['seller_name']!,
      };
      var score = 0.0;
      for (final term in expandedTerms) {
        for (final entry in haystacks.entries) {
          if (term.isNotEmpty && entry.key.contains(term)) {
            score += entry.value;
          }
        }
      }
      if (score > 0) {
        entries.add(MapEntry<String, double>(item.id, score + item.watchers * 0.05));
      }
    }
    entries.sort((MapEntry<String, double> a, MapEntry<String, double> b) => b.value.compareTo(a.value));
    return entries.map((MapEntry<String, double> e) => e.key).toList(growable: false);
  }

  List<String> searchWanted(
    List<Wanted> items,
    String query, {
    Map<String, User>? users,
    String locale = 'en_US',
  }) {
    if (query.trim().isEmpty) {
      return items.map((Wanted e) => e.id).toList(growable: false);
    }
    final expandedTerms = synonymsService.expand(query, locale: locale);
    final entries = <MapEntry<String, double>>[];
    for (final item in items) {
      final requesterName = users?[item.requesterId]?.name.toLowerCase() ?? '';
      final haystacks = <String, double>{
        item.title.toLowerCase(): _weights['title']!,
        item.category.toLowerCase(): _weights['category']!,
        item.specs.toLowerCase(): _weights['description']!,
        item.location.toLowerCase(): _weights['location']!,
        requesterName: _weights['requester_name']!,
      };
      var score = 0.0;
      for (final term in expandedTerms) {
        for (final entry in haystacks.entries) {
          if (term.isNotEmpty && entry.key.contains(term)) {
            score += entry.value;
          }
        }
      }
      if (score > 0) {
        entries.add(MapEntry<String, double>(item.id, score));
      }
    }
    entries.sort((MapEntry<String, double> a, MapEntry<String, double> b) => b.value.compareTo(a.value));
    return entries.map((MapEntry<String, double> e) => e.key).toList(growable: false);
  }
}
