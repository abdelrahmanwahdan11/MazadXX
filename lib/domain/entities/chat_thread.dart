class ChatThread {
  const ChatThread({
    required this.id,
    required this.users,
    required this.lastMessage,
    required this.updatedAt,
  });

  final String id;
  final List<String> users;
  final String lastMessage;
  final DateTime updatedAt;
}
