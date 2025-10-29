import '../entities/entities.dart';
import '../repositories/repositories.dart';

class GetWantedByIdUseCase {
  const GetWantedByIdUseCase(this.repository);

  final WantedRepository repository;

  Future<Wanted?> call(String id) => repository.findById(id);
}
