import '../../domain/entities/entities.dart';
import '../../domain/repositories/auction_repository.dart';
import '../local_data/asset_loader.dart';
import '../models/auction_item.dart';
import '../models/bid_model.dart';

class AuctionRepositoryImpl implements AuctionRepository {
  AuctionRepositoryImpl(this._loader);

  final AssetLoader _loader;
  final Map<String, List<BidModel>> _bids = <String, List<BidModel>>{};
  List<AuctionItem>? _cache;

  Future<void> _ensureLoaded({bool refresh = false}) async {
    if (_cache != null && !refresh) {
      return;
    }
    final data = await _loader.loadList('assets/data/auctions.json');
    _cache = data
        .map((dynamic e) => AuctionItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<Auction>> fetchAll({bool refresh = false}) async {
    await _ensureLoaded(refresh: refresh);
    return List<Auction>.unmodifiable(_cache ?? <AuctionItem>[]);
  }

  @override
  Future<List<Auction>> fetchFeatured() async {
    await _ensureLoaded();
    final items = List<AuctionItem>.from(_cache ?? <AuctionItem>[]);
    items.sort((AuctionItem a, AuctionItem b) => b.watchers.compareTo(a.watchers));
    return items.take(6).toList(growable: false);
  }

  @override
  Future<List<Auction>> fetchByIds(List<String> ids) async {
    await _ensureLoaded();
    final map = <String, AuctionItem>{
      for (final item in _cache ?? <AuctionItem>[]) item.id: item,
    };
    return ids
        .map((String id) => map[id])
        .whereType<Auction>()
        .toList(growable: false);
  }

  @override
  Future<Auction?> findById(String id) async {
    await _ensureLoaded();
    try {
      return _cache?.firstWhere((AuctionItem element) => element.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<Bid>> fetchBids(String auctionId) async {
    await _ensureLoaded();
    final bids = _bids.putIfAbsent(auctionId, () => <BidModel>[]);
    bids.sort((BidModel a, BidModel b) => b.time.compareTo(a.time));
    return List<Bid>.unmodifiable(bids);
  }

  @override
  Future<void> addBid(String auctionId, Bid bid) async {
    await _ensureLoaded();
    final current = _cache?.map((AuctionItem e) => e).toList() ?? <AuctionItem>[];
    final index = current.indexWhere((AuctionItem element) => element.id == auctionId);
    if (index >= 0) {
      final updated = current[index].copyWith(currentBid: bid.amount);
      current[index] = updated;
      _cache = current;
    }
    final list = _bids.putIfAbsent(auctionId, () => <BidModel>[]);
    if (bid is BidModel) {
      list.add(bid);
    } else {
      list.add(
        BidModel(
          id: bid.id,
          auctionId: auctionId,
          userId: bid.userId,
          amount: bid.amount,
          time: bid.time,
        ),
      );
    }
  }
}
