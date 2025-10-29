import 'package:get/get.dart';

import '../../domain/entities/entities.dart';
import '../../domain/usecases/usecases.dart';

class CategoriesController extends GetxController {
  CategoriesController(this.getCategoriesUseCase);

  final GetCategoriesUseCase getCategoriesUseCase;

  final RxList<Category> categories = <Category>[].obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    categories.assignAll(await getCategoriesUseCase());
  }
}
