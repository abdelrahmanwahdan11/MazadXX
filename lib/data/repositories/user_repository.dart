import '../local_data/asset_loader.dart';
import '../models/user.dart';

class UserRepository {
  UserRepository(this._loader);

  final AssetLoader _loader;

  Future<Map<String, User>> fetchUsers() async {
    final data = await _loader.loadList('assets/data/users.json');
    final users = data.map((e) => User.fromJson(e as Map<String, dynamic>));
    return {for (final user in users) user.id: user};
  }
}
