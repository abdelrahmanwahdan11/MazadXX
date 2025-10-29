import '../entities/entities.dart';
import '../repositories/repositories.dart';

class GetUserByIdUseCase {
  const GetUserByIdUseCase(this.repository);

  final UserRepository repository;

  Future<User?> call(String id) => repository.findById(id);
}
