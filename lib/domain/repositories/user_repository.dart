import '../entities/entities.dart';

abstract class UserRepository {
  Future<User?> findById(String id);
  Future<List<User>> fetchAll();
}
