import '../entities/entities.dart';

abstract class ChatRepository {
  Future<List<ChatThread>> fetchThreads();
  Future<List<Message>> fetchMessages(String threadId);
  Future<void> addMessage(String threadId, Message message);
}
