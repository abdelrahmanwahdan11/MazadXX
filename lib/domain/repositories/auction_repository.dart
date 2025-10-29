import '../entities/entities.dart';

abstract class AuctionRepository {
  Future<List<Auction>> fetchAll({bool refresh = false});
  Future<List<Auction>> fetchFeatured();
  Future<List<Auction>> fetchByIds(List<String> ids);
  Future<Auction?> findById(String id);
  Future<List<Bid>> fetchBids(String auctionId);
  Future<void> addBid(String auctionId, Bid bid);
}
