import '../entities/entities.dart';
import '../repositories/repositories.dart';

class GetThreadsUseCase {
  const GetThreadsUseCase(this.repository);

  final ChatRepository repository;

  Future<List<ChatThread>> call() => repository.fetchThreads();
}
