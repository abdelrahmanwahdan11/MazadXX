import '../entities/entities.dart';
import '../repositories/repositories.dart';

class AddBidUseCase {
  const AddBidUseCase(this.repository);

  final AuctionRepository repository;

  Future<void> call(String auctionId, Bid bid) {
    return repository.addBid(auctionId, bid);
  }
}
