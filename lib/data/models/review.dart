class Review {
  const Review({
    required this.user,
    required this.stars,
    required this.text,
    required this.date,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        user: json['user'] as String,
        stars: (json['stars'] as num?)?.toDouble() ?? 0,
        text: json['text'] as String? ?? '',
        date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
      );

  final String user;
  final double stars;
  final String text;
  final DateTime date;
}
