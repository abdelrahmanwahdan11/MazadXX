import '../entities/entities.dart';
import '../repositories/repositories.dart';

class AddMessageUseCase {
  const AddMessageUseCase(this.repository);

  final ChatRepository repository;

  Future<void> call(String threadId, Message message) {
    return repository.addMessage(threadId, message);
  }
}
