import '../entities/entities.dart';
import '../repositories/repositories.dart';

class GetWantedUseCase {
  const GetWantedUseCase(this.repository);

  final WantedRepository repository;

  Future<List<Wanted>> call({bool refresh = false}) {
    return repository.fetchAll(refresh: refresh);
  }
}
