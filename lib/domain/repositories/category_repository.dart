import '../entities/entities.dart';

abstract class CategoryRepository {
  Future<List<Category>> fetchCategories();
}
