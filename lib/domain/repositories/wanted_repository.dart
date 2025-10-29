import '../entities/entities.dart';

abstract class WantedRepository {
  Future<List<Wanted>> fetchAll({bool refresh = false});
  Future<List<Wanted>> fetchByIds(List<String> ids);
  Future<Wanted?> findById(String id);
  Future<List<Offer>> fetchOffers(String wantedId);
  Future<void> addOffer(String wantedId, Offer offer);
}
