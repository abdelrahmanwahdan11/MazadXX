class User {
  const User({
    required this.id,
    required this.name,
    required this.avatar,
    required this.rating,
    required this.wins,
    required this.bids,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final stats = json['stats'] as Map<String, dynamic>? ?? {};
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      avatar: json['avatar'] as String? ?? 'assets/images/avatars/default.png',
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      wins: (stats['wins'] as num?)?.toInt() ?? 0,
      bids: (stats['bids'] as num?)?.toInt() ?? 0,
    );
  }

  final String id;
  final String name;
  final String avatar;
  final double rating;
  final int wins;
  final int bids;

}
