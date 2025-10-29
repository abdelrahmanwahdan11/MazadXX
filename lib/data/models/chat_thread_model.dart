import '../../domain/entities/chat_thread.dart';

class ChatThreadModel extends ChatThread {
  const ChatThreadModel({
    required super.id,
    required super.users,
    required super.lastMessage,
    required super.updatedAt,
  });

  factory ChatThreadModel.fromJson(Map<String, dynamic> json) => ChatThreadModel(
        id: json['id'] as String,
        users: List<String>.from(json['users'] as List<dynamic>? ?? <String>[]),
        lastMessage: json['last_message'] as String? ?? '',
        updatedAt: DateTime.parse(json['updated_at'] as String),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'users': users,
        'last_message': lastMessage,
        'updated_at': updatedAt.toIso8601String(),
      };
}
