import '../../domain/entities/entities.dart';
import '../../domain/repositories/user_repository.dart' as domain;
import '../local_data/asset_loader.dart';
import '../models/user.dart';

class UserRepositoryImpl implements domain.UserRepository {
  UserRepositoryImpl(this._loader);

  final AssetLoader _loader;
  Map<String, UserModel>? _cache;

  Future<void> _ensureLoaded() async {
    if (_cache != null) {
      return;
    }
    final data = await _loader.loadList('assets/data/users.json');
    final users = data
        .map((dynamic e) => UserModel.fromJson(e as Map<String, dynamic>))
        .toList();
    _cache = {for (final user in users) user.id: user};
  }

  @override
  Future<User?> findById(String id) async {
    await _ensureLoaded();
    return _cache?[id];
  }

  @override
  Future<List<User>> fetchAll() async {
    await _ensureLoaded();
    return List<User>.unmodifiable(_cache?.values ?? <UserModel>[]);
  }
}
