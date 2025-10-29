import '../entities/entities.dart';
import '../repositories/repositories.dart';

class GetFeaturedAuctionsUseCase {
  const GetFeaturedAuctionsUseCase(this.repository);

  final AuctionRepository repository;

  Future<List<Auction>> call() => repository.fetchFeatured();
}
