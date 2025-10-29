import '../entities/entities.dart';
import '../repositories/repositories.dart';

class GetCategoriesUseCase {
  const GetCategoriesUseCase(this.repository);

  final CategoryRepository repository;

  Future<List<Category>> call() => repository.fetchCategories();
}
