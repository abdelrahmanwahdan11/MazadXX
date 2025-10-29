import '../entities/entities.dart';
import '../repositories/repositories.dart';

class AddOfferUseCase {
  const AddOfferUseCase(this.repository);

  final WantedRepository repository;

  Future<void> call(String wantedId, Offer offer) {
    return repository.addOffer(wantedId, offer);
  }
}
