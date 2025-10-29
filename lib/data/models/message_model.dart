import '../../domain/entities/message.dart';

class MessageModel extends Message {
  const MessageModel({
    required super.id,
    required super.threadId,
    required super.senderId,
    required super.text,
    required super.image,
    required super.time,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
        id: json['id'] as String,
        threadId: json['thread_id'] as String,
        senderId: json['sender_id'] as String,
        text: json['text'] as String? ?? '',
        image: json['image'] as String?,
        time: DateTime.parse(json['time'] as String),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'thread_id': threadId,
        'sender_id': senderId,
        'text': text,
        'image': image,
        'time': time.toIso8601String(),
      };
}
