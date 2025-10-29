import '../entities/entities.dart';
import '../repositories/repositories.dart';

class GetAuctionsUseCase {
  const GetAuctionsUseCase(this.repository);

  final AuctionRepository repository;

  Future<List<Auction>> call({bool refresh = false}) {
    return repository.fetchAll(refresh: refresh);
  }
}
