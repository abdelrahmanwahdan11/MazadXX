import '../local_data/asset_loader.dart';
import '../models/category.dart';

class CategoryRepository {
  CategoryRepository(this._loader);

  final AssetLoader _loader;

  Future<List<Category>> fetchCategories() async {
    final data = await _loader.loadList('assets/data/categories.json');
    return data.map((e) => Category.fromJson(e as Map<String, dynamic>)).toList();
  }
}
