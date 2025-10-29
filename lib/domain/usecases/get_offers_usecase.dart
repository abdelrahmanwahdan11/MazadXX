import '../entities/entities.dart';
import '../repositories/repositories.dart';

class GetOffersUseCase {
  const GetOffersUseCase(this.repository);

  final WantedRepository repository;

  Future<List<Offer>> call(String wantedId) {
    return repository.fetchOffers(wantedId);
  }
}
