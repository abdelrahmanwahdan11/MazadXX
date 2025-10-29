import '../../domain/entities/saved_filter.dart';

class SavedFilterModel extends SavedFilter {
  const SavedFilterModel({
    required super.id,
    required super.scope,
    required super.payload,
    required super.label,
  });

  factory SavedFilterModel.fromJson(Map<String, dynamic> json) => SavedFilterModel(
        id: json['id'] as String,
        scope: json['scope'] as String,
        payload: (json['payload'] as Map<String, dynamic>? ?? <String, dynamic>{})
            .map((key, value) => MapEntry(key, value)),
        label: json['label'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'scope': scope,
        'payload': payload,
        'label': label,
      };
}
