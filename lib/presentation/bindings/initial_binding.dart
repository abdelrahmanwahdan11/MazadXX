import 'package:get/get.dart';

import '../../application/services/action_log.dart';
import '../../application/services/format_service.dart';
import '../../application/services/i18n_audit_service.dart';
import '../../application/services/index_service.dart';
import '../../application/services/lifecycle_handlers.dart';
import '../../application/services/local_store.dart';
import '../../application/services/schema_migrations.dart';
import '../../application/services/synonyms_service.dart';
import '../../data/local_data/asset_loader.dart';
import '../../data/repositories/auction_repository_impl.dart';
import '../../data/repositories/category_repository_impl.dart';
import '../../data/repositories/chat_repository_impl.dart';
import '../../data/repositories/report_repository_impl.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../data/repositories/wanted_repository_impl.dart';
import '../../domain/repositories/repositories.dart' as domain;
import '../../domain/usecases/usecases.dart';
import '../controllers/controllers.dart';

class InitialBinding extends Bindings {
  InitialBinding({required this.localStore, required this.schemaMigrations});

  final LocalStore localStore;
  final SchemaMigrations schemaMigrations;

  @override
  void dependencies() {
    Get.put<LocalStore>(localStore, permanent: true);
    Get.put<SchemaMigrations>(schemaMigrations, permanent: true);
    Get.put(ActionLog(capacity: 128), permanent: true);
    Get.put(I18nAuditService(), permanent: true);
    Get.put(SynonymsService(), permanent: true);
    Get.put(IndexService(synonymsService: Get.find()), permanent: true);
    Get.put(FormatService(currencySymbol: 'ر.ق'), permanent: true);

    final loader = AssetLoader();
    Get.put(loader, permanent: true);

    Get.lazyPut<domain.AuctionRepository>(() => AuctionRepositoryImpl(loader));
    Get.lazyPut<domain.WantedRepository>(() => WantedRepositoryImpl(loader));
    Get.lazyPut<domain.CategoryRepository>(() => CategoryRepositoryImpl(loader));
    Get.lazyPut<domain.UserRepository>(() => UserRepositoryImpl(loader));
    Get.lazyPut<domain.ChatRepository>(() => ChatRepositoryImpl());
    Get.lazyPut<domain.ReportRepository>(() => ReportRepositoryImpl());

    Get.lazyPut(() => GetAuctionsUseCase(Get.find<domain.AuctionRepository>()));
    Get.lazyPut(() => GetAuctionByIdUseCase(Get.find<domain.AuctionRepository>()));
    Get.lazyPut(() => GetFeaturedAuctionsUseCase(Get.find<domain.AuctionRepository>()));
    Get.lazyPut(() => GetBidsUseCase(Get.find<domain.AuctionRepository>()));
    Get.lazyPut(() => AddBidUseCase(Get.find<domain.AuctionRepository>()));

    Get.lazyPut(() => GetWantedUseCase(Get.find<domain.WantedRepository>()));
    Get.lazyPut(() => GetWantedByIdUseCase(Get.find<domain.WantedRepository>()));
    Get.lazyPut(() => GetOffersUseCase(Get.find<domain.WantedRepository>()));
    Get.lazyPut(() => AddOfferUseCase(Get.find<domain.WantedRepository>()));

    Get.lazyPut(() => GetCategoriesUseCase(Get.find<domain.CategoryRepository>()));
    Get.lazyPut(() => GetUserByIdUseCase(Get.find<domain.UserRepository>()));
    Get.lazyPut(() => GetThreadsUseCase(Get.find<domain.ChatRepository>()));
    Get.lazyPut(() => GetMessagesUseCase(Get.find<domain.ChatRepository>()));
    Get.lazyPut(() => AddMessageUseCase(Get.find<domain.ChatRepository>()));

    Get.lazyPut(() => LifecycleHandlers(Get.find<ActionLog>()), fenix: true);

    Get.put(ThemeController(), permanent: true);
    Get.put(LocaleController(), permanent: true);

    Get.lazyPut(() => HomeController(
          featuredAuctions: Get.find<GetFeaturedAuctionsUseCase>(),
          auctionsUseCase: Get.find<GetAuctionsUseCase>(),
          wantedUseCase: Get.find<GetWantedUseCase>(),
          categoriesUseCase: Get.find<GetCategoriesUseCase>(),
          formatService: Get.find<FormatService>(),
          indexService: Get.find<IndexService>(),
          userRepository: Get.find<domain.UserRepository>(),
        ));

    Get.lazyPut(() => AuctionsController(
          auctionsUseCase: Get.find<GetAuctionsUseCase>(),
          bidsUseCase: Get.find<GetBidsUseCase>(),
          addBidUseCase: Get.find<AddBidUseCase>(),
          userRepository: Get.find<domain.UserRepository>(),
          indexService: Get.find<IndexService>(),
          actionLog: Get.find<ActionLog>(),
          localStore: Get.find<LocalStore>(),
          formatService: Get.find<FormatService>(),
        ));

    Get.lazyPut(() => WantedController(
          wantedUseCase: Get.find<GetWantedUseCase>(),
          offersUseCase: Get.find<GetOffersUseCase>(),
          addOfferUseCase: Get.find<AddOfferUseCase>(),
          userRepository: Get.find<domain.UserRepository>(),
          indexService: Get.find<IndexService>(),
          actionLog: Get.find<ActionLog>(),
          localStore: Get.find<LocalStore>(),
          formatService: Get.find<FormatService>(),
        ));

    Get.lazyPut(() => AuctionDetailController(
          getAuctionByIdUseCase: Get.find<GetAuctionByIdUseCase>(),
          getBidsUseCase: Get.find<GetBidsUseCase>(),
          addBidUseCase: Get.find<AddBidUseCase>(),
          formatService: Get.find<FormatService>(),
          actionLog: Get.find<ActionLog>(),
        ));

    Get.lazyPut(() => WantedDetailController(
          getWantedByIdUseCase: Get.find<GetWantedByIdUseCase>(),
          getOffersUseCase: Get.find<GetOffersUseCase>(),
          addOfferUseCase: Get.find<AddOfferUseCase>(),
          formatService: Get.find<FormatService>(),
          actionLog: Get.find<ActionLog>(),
        ));

    Get.lazyPut(() => SearchController(
          auctionsUseCase: Get.find<GetAuctionsUseCase>(),
          wantedUseCase: Get.find<GetWantedUseCase>(),
          indexService: Get.find<IndexService>(),
          localStore: Get.find<LocalStore>(),
          userRepository: Get.find<domain.UserRepository>(),
        ));

    Get.lazyPut(() => FiltersController(localStore: Get.find<LocalStore>()));

    Get.lazyPut(() => WalletController(localStore: Get.find<LocalStore>(), formatService: Get.find<FormatService>()));

    Get.lazyPut(() => MessagesController(
          getThreadsUseCase: Get.find<GetThreadsUseCase>(),
          getMessagesUseCase: Get.find<GetMessagesUseCase>(),
          addMessageUseCase: Get.find<AddMessageUseCase>(),
          actionLog: Get.find<ActionLog>(),
        ));

    Get.lazyPut(() => NotificationsController(Get.find<ActionLog>()));

    Get.lazyPut(() => WatchlistController(
          localStore: Get.find<LocalStore>(),
          auctionsUseCase: Get.find<GetAuctionsUseCase>(),
          wantedUseCase: Get.find<GetWantedUseCase>(),
        ));

    Get.lazyPut(() => ProfileController(
          getUserByIdUseCase: Get.find<GetUserByIdUseCase>(),
          localStore: Get.find<LocalStore>(),
        ));

    Get.lazyPut(() => SettingsController(
          themeController: Get.find<ThemeController>(),
          localeController: Get.find<LocaleController>(),
          localStore: Get.find<LocalStore>(),
          actionLog: Get.find<ActionLog>(),
          auditService: Get.find<I18nAuditService>(),
        ));

    Get.lazyPut(() => ProviderController(Get.find<LocalStore>()));
    Get.lazyPut(() => ModerationController(Get.find<domain.ReportRepository>()));
    Get.lazyPut(() => ReportsController(Get.find<LocalStore>()));

    Get.lazyPut(() => QaController(
          actionLog: Get.find<ActionLog>(),
          auditService: Get.find<I18nAuditService>(),
          indexService: Get.find<IndexService>(),
        ));

    Get.lazyPut(() => CategoriesController(Get.find<GetCategoriesUseCase>()));
    Get.lazyPut(() => AuthController(Get.find<LocalStore>()));
    Get.lazyPut(() => OnboardingController(Get.find<LocalStore>()));
    Get.lazyPut(() => SplashController());
  }
}
