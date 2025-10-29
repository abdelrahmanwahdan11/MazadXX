import 'package:get/get.dart';

import '../../application/services/action_log.dart';
import '../../application/services/index_service.dart';
import '../../application/services/local_store.dart';
import '../../data/local_data/asset_loader.dart';
import '../../data/repositories/auction_repository.dart';
import '../../data/repositories/category_repository.dart';
import '../../data/repositories/wanted_repository.dart';
import '../controllers/auctions_controller.dart';
import '../controllers/home_controller.dart';
import '../controllers/locale_controller.dart';
import '../controllers/theme_controller.dart';
import '../controllers/wanted_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ThemeController(), permanent: true);
    Get.put(LocaleController(), permanent: true);
    Get.put(ActionLog(), permanent: true);
    Get.put(LocalStore(), permanent: true);

    final loader = AssetLoader();
    Get.put(loader, permanent: true);

    Get.lazyPut(() => AuctionRepository(loader));
    Get.lazyPut(() => WantedRepository(loader));
    Get.lazyPut(() => CategoryRepository(loader));

    Get.put(IndexService(), permanent: true);

    Get.lazyPut(() => HomeController(auctionRepository: Get.find()));
    Get.lazyPut(
      () => AuctionsController(
        auctionRepository: Get.find(),
        indexService: Get.find(),
        actionLog: Get.find(),
      ),
    );
    Get.lazyPut(
      () => WantedController(
        wantedRepository: Get.find(),
        indexService: Get.find(),
        actionLog: Get.find(),
      ),
    );
  }
}
