import '../entities/entities.dart';
import '../repositories/repositories.dart';

class GetBidsUseCase {
  const GetBidsUseCase(this.repository);

  final AuctionRepository repository;

  Future<List<Bid>> call(String auctionId) {
    return repository.fetchBids(auctionId);
  }
}
