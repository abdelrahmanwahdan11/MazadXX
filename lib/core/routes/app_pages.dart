import 'package:get/get.dart';

import '../../presentation/pages/auctions_page.dart';
import '../../presentation/pages/home_page.dart';
import '../../presentation/pages/placeholder_page.dart';
import '../../presentation/pages/splash_page.dart';
import '../../presentation/pages/wanted_page.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static final pages = <GetPage<dynamic>>[
    GetPage(name: AppRoutes.splash, page: () => const SplashPage()),
    GetPage(name: AppRoutes.home, page: () => const HomePage()),
    GetPage(name: AppRoutes.auctions, page: () => const AuctionsPage()),
    GetPage(name: AppRoutes.wanted, page: () => const WantedPage()),
    GetPage(name: AppRoutes.auctionDetails, page: () => const PlaceholderPage(titleKey: 'auctions')),
    GetPage(name: AppRoutes.wantedDetails, page: () => const PlaceholderPage(titleKey: 'wanted')),
    GetPage(name: AppRoutes.onboarding, page: () => const PlaceholderPage(titleKey: 'browse')),
    GetPage(name: AppRoutes.login, page: () => const PlaceholderPage(titleKey: 'login')),
    GetPage(name: AppRoutes.signup, page: () => const PlaceholderPage(titleKey: 'signup')),
    GetPage(name: AppRoutes.post, page: () => const PlaceholderPage(titleKey: 'post')),
    GetPage(name: AppRoutes.messages, page: () => const PlaceholderPage(titleKey: 'messages')),
    GetPage(name: AppRoutes.chat, page: () => const PlaceholderPage(titleKey: 'chat')),
    GetPage(name: AppRoutes.categories, page: () => const PlaceholderPage(titleKey: 'filters')),
    GetPage(name: AppRoutes.search, page: () => const PlaceholderPage(titleKey: 'search')),
    GetPage(name: AppRoutes.filters, page: () => const PlaceholderPage(titleKey: 'filters')),
    GetPage(name: AppRoutes.watchlist, page: () => const PlaceholderPage(titleKey: 'watchlist')),
    GetPage(name: AppRoutes.wallet, page: () => const PlaceholderPage(titleKey: 'wallet')),
    GetPage(name: AppRoutes.notifications, page: () => const PlaceholderPage(titleKey: 'notifications')),
    GetPage(name: AppRoutes.profile, page: () => const PlaceholderPage(titleKey: 'profile')),
    GetPage(name: AppRoutes.settings, page: () => const PlaceholderPage(titleKey: 'settings')),
    GetPage(name: AppRoutes.provider, page: () => const PlaceholderPage(titleKey: 'provider')),
    GetPage(name: AppRoutes.moderation, page: () => const PlaceholderPage(titleKey: 'moderation')),
    GetPage(name: AppRoutes.reports, page: () => const PlaceholderPage(titleKey: 'reports')),
    GetPage(name: AppRoutes.qa, page: () => const PlaceholderPage(titleKey: 'qa')),
  ];
}
