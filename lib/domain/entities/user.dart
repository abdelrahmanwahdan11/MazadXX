class User {
  const User({
    required this.id,
    required this.name,
    required this.avatar,
    required this.rating,
    required this.stats,
  });

  final String id;
  final String name;
  final String avatar;
  final double rating;
  final Map<String, dynamic> stats;
}
