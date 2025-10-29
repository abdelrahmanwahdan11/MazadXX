import '../../domain/entities/saved_search.dart';

class SavedSearchModel extends SavedSearch {
  const SavedSearchModel({
    required super.id,
    required super.scope,
    required super.query,
    required super.filters,
    required super.date,
  });

  factory SavedSearchModel.fromJson(Map<String, dynamic> json) => SavedSearchModel(
        id: json['id'] as String,
        scope: json['scope'] as String,
        query: json['query'] as String? ?? '',
        filters: (json['filters'] as Map<String, dynamic>? ?? <String, dynamic>{})
            .map((key, value) => MapEntry(key, value)),
        date: DateTime.parse(json['date'] as String),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'scope': scope,
        'query': query,
        'filters': filters,
        'date': date.toIso8601String(),
      };
}
