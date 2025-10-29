import '../../domain/entities/review.dart';

class ReviewModel extends Review {
  ReviewModel({
    required super.user,
    required super.stars,
    required super.text,
    required super.date,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) => ReviewModel(
        user: json['user'] as String,
        stars: (json['stars'] as num?)?.toDouble() ?? 0,
        text: json['text'] as String? ?? '',
        date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'user': user,
        'stars': stars,
        'text': text,
        'date': date.toIso8601String(),
      };
}
