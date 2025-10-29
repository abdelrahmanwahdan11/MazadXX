class Review {
  const Review({
    required this.user,
    required this.stars,
    required this.text,
    required this.date,
  });

  final String user;
  final double stars;
  final String text;
  final DateTime date;
}
