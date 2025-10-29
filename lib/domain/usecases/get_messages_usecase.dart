import '../entities/entities.dart';
import '../repositories/repositories.dart';

class GetMessagesUseCase {
  const GetMessagesUseCase(this.repository);

  final ChatRepository repository;

  Future<List<Message>> call(String threadId) => repository.fetchMessages(threadId);
}
