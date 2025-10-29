import '../../domain/entities/entities.dart';
import '../../domain/repositories/category_repository.dart' as domain;
import '../local_data/asset_loader.dart';
import '../models/category_model.dart';

class CategoryRepositoryImpl implements domain.CategoryRepository {
  CategoryRepositoryImpl(this._loader);

  final AssetLoader _loader;
  List<CategoryModel>? _cache;

  Future<void> _ensureLoaded() async {
    if (_cache != null) {
      return;
    }
    final data = await _loader.loadList('assets/data/categories.json');
    _cache = data
        .map((dynamic e) => CategoryModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<Category>> fetchCategories() async {
    await _ensureLoaded();
    return List<Category>.unmodifiable(_cache ?? <CategoryModel>[]);
  }
}
