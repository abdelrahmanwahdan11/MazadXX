import '../entities/entities.dart';
import '../repositories/repositories.dart';

class GetAuctionByIdUseCase {
  const GetAuctionByIdUseCase(this.repository);

  final AuctionRepository repository;

  Future<Auction?> call(String id) => repository.findById(id);
}
