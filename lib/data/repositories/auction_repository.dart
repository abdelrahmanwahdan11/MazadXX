import '../local_data/asset_loader.dart';
import '../models/auction_item.dart';

class AuctionRepository {
  AuctionRepository(this._loader);

  final AssetLoader _loader;

  Future<List<AuctionItem>> fetchAuctions() async {
    final data = await _loader.loadList('assets/data/auctions.json');
    return data.map((e) => AuctionItem.fromJson(e as Map<String, dynamic>)).toList();
  }
}
