import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.avatar,
    required super.rating,
    required super.stats,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final stats = (json['stats'] as Map<String, dynamic>? ?? <String, dynamic>{}).map(
      (key, value) => MapEntry(key, value),
    );
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      avatar: json['avatar'] as String? ?? 'assets/images/avatars/default.png',
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      stats: stats,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'avatar': avatar,
        'rating': rating,
        'stats': stats,
      };
}
