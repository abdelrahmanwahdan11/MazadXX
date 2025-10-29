import '../local_data/asset_loader.dart';
import '../models/wanted_item.dart';

class WantedRepository {
  WantedRepository(this._loader);

  final AssetLoader _loader;

  Future<List<WantedItem>> fetchWanted() async {
    final data = await _loader.loadList('assets/data/wanted.json');
    return data.map((e) => WantedItem.fromJson(e as Map<String, dynamic>)).toList();
  }
}
