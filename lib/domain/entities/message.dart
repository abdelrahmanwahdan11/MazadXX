class Message {
  const Message({
    required this.id,
    required this.threadId,
    required this.senderId,
    required this.text,
    required this.image,
    required this.time,
  });

  final String id;
  final String threadId;
  final String senderId;
  final String text;
  final String? image;
  final DateTime time;
}
