import 'package:get/get.dart';

import '../../presentation/controllers/controllers.dart';
import '../../presentation/pages/auction_detail_page.dart';
import '../../presentation/pages/auctions_page.dart';
import '../../presentation/pages/categories_page.dart';
import '../../presentation/pages/chat_page.dart';
import '../../presentation/pages/filters_page.dart';
import '../../presentation/pages/home_page.dart';
import '../../presentation/pages/login_page.dart';
import '../../presentation/pages/messages_page.dart';
import '../../presentation/pages/moderation_page.dart';
import '../../presentation/pages/notifications_page.dart';
import '../../presentation/pages/onboarding_page.dart';
import '../../presentation/pages/post_page.dart';
import '../../presentation/pages/profile_page.dart';
import '../../presentation/pages/provider_page.dart';
import '../../presentation/pages/qa_page.dart';
import '../../presentation/pages/reports_page.dart';
import '../../presentation/pages/search_page.dart';
import '../../presentation/pages/settings_page.dart';
import '../../presentation/pages/signup_page.dart';
import '../../presentation/pages/splash_page.dart';
import '../../presentation/pages/wallet_page.dart';
import '../../presentation/pages/watchlist_page.dart';
import '../../presentation/pages/wanted_detail_page.dart';
import '../../presentation/pages/wanted_page.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static final pages = <GetPage<dynamic>>[
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashPage(),
      binding: BindingsBuilder(() => Get.find<SplashController>()),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomePage(),
      binding: BindingsBuilder(() => Get.find<HomeController>()),
    ),
    GetPage(
      name: AppRoutes.auctions,
      page: () => const AuctionsPage(),
      binding: BindingsBuilder(() => Get.find<AuctionsController>()),
    ),
    GetPage(
      name: AppRoutes.auctionDetails,
      page: () => const AuctionDetailPage(),
      binding: BindingsBuilder(() => Get.find<AuctionDetailController>()),
    ),
    GetPage(
      name: AppRoutes.wanted,
      page: () => const WantedPage(),
      binding: BindingsBuilder(() => Get.find<WantedController>()),
    ),
    GetPage(
      name: AppRoutes.wantedDetails,
      page: () => const WantedDetailPage(),
      binding: BindingsBuilder(() => Get.find<WantedDetailController>()),
    ),
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingPage(),
      binding: BindingsBuilder(() => Get.find<OnboardingController>()),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPage(),
      binding: BindingsBuilder(() => Get.find<AuthController>()),
    ),
    GetPage(
      name: AppRoutes.signup,
      page: () => const SignupPage(),
      binding: BindingsBuilder(() => Get.find<AuthController>()),
    ),
    GetPage(
      name: AppRoutes.post,
      page: () => const PostPage(),
      binding: BindingsBuilder(() => Get.find<PostController>()),
    ),
    GetPage(
      name: AppRoutes.messages,
      page: () => const MessagesPage(),
      binding: BindingsBuilder(() => Get.find<MessagesController>()),
    ),
    GetPage(
      name: AppRoutes.chat,
      page: () => const ChatPage(),
      binding: BindingsBuilder(() => Get.find<MessagesController>()),
    ),
    GetPage(
      name: AppRoutes.categories,
      page: () => const CategoriesPage(),
      binding: BindingsBuilder(() => Get.find<CategoriesController>()),
    ),
    GetPage(
      name: AppRoutes.search,
      page: () => const SearchPage(),
      binding: BindingsBuilder(() => Get.find<SearchController>()),
    ),
    GetPage(
      name: AppRoutes.filters,
      page: () => const FiltersPage(),
      binding: BindingsBuilder(() => Get.find<FiltersController>()),
    ),
    GetPage(
      name: AppRoutes.watchlist,
      page: () => const WatchlistPage(),
      binding: BindingsBuilder(() => Get.find<WatchlistController>()),
    ),
    GetPage(
      name: AppRoutes.wallet,
      page: () => const WalletPage(),
      binding: BindingsBuilder(() => Get.find<WalletController>()),
    ),
    GetPage(
      name: AppRoutes.notifications,
      page: () => const NotificationsPage(),
      binding: BindingsBuilder(() => Get.find<NotificationsController>()),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfilePage(),
      binding: BindingsBuilder(() => Get.find<ProfileController>()),
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsPage(),
      binding: BindingsBuilder(() => Get.find<SettingsController>()),
    ),
    GetPage(
      name: AppRoutes.provider,
      page: () => const ProviderPage(),
      binding: BindingsBuilder(() => Get.find<ProviderController>()),
    ),
    GetPage(
      name: AppRoutes.moderation,
      page: () => const ModerationPage(),
      binding: BindingsBuilder(() => Get.find<ModerationController>()),
    ),
    GetPage(
      name: AppRoutes.reports,
      page: () => const ReportsPage(),
      binding: BindingsBuilder(() => Get.find<ReportsController>()),
    ),
    GetPage(
      name: AppRoutes.qa,
      page: () => const QaPage(),
      binding: BindingsBuilder(() => Get.find<QaController>()),
    ),
  ];
}
