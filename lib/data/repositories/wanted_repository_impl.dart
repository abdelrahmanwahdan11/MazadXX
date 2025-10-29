import '../../domain/entities/entities.dart';
import '../../domain/repositories/wanted_repository.dart';
import '../local_data/asset_loader.dart';
import '../models/offer_model.dart';
import '../models/wanted_item.dart';

class WantedRepositoryImpl implements WantedRepository {
  WantedRepositoryImpl(this._loader);

  final AssetLoader _loader;
  final Map<String, List<OfferModel>> _offers = <String, List<OfferModel>>{};
  List<WantedItem>? _cache;

  Future<void> _ensureLoaded({bool refresh = false}) async {
    if (_cache != null && !refresh) {
      return;
    }
    final data = await _loader.loadList('assets/data/wanted.json');
    _cache = data
        .map((dynamic e) => WantedItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<Wanted>> fetchAll({bool refresh = false}) async {
    await _ensureLoaded(refresh: refresh);
    return List<Wanted>.unmodifiable(_cache ?? <WantedItem>[]);
  }

  @override
  Future<List<Wanted>> fetchByIds(List<String> ids) async {
    await _ensureLoaded();
    final map = <String, WantedItem>{
      for (final item in _cache ?? <WantedItem>[]) item.id: item,
    };
    return ids
        .map((String id) => map[id])
        .whereType<Wanted>()
        .toList(growable: false);
  }

  @override
  Future<Wanted?> findById(String id) async {
    await _ensureLoaded();
    try {
      return _cache?.firstWhere((WantedItem element) => element.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<Offer>> fetchOffers(String wantedId) async {
    await _ensureLoaded();
    final offers = _offers.putIfAbsent(wantedId, () => <OfferModel>[]);
    offers.sort((OfferModel a, OfferModel b) => b.time.compareTo(a.time));
    return List<Offer>.unmodifiable(offers);
  }

  @override
  Future<void> addOffer(String wantedId, Offer offer) async {
    await _ensureLoaded();
    final list = _offers.putIfAbsent(wantedId, () => <OfferModel>[]);
    if (offer is OfferModel) {
      list.add(offer);
    } else {
      list.add(
        OfferModel(
          id: offer.id,
          wantedId: wantedId,
          userId: offer.userId,
          amount: offer.amount,
          message: offer.message,
          time: offer.time,
        ),
      );
    }
  }
}
