import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

import '../../core/routes/app_routes.dart';

class AppShell extends StatelessWidget {
  const AppShell({
    super.key,
    required this.child,
    required this.currentRoute,
    this.floatingActionButton,
    this.endDrawer,
  });

  final Widget child;
  final String currentRoute;
  final Widget? floatingActionButton;
  final Widget? endDrawer;

  static const _navItems = <_NavItem>[
    _NavItem(route: AppRoutes.auctions, labelKey: 'auctions', icon: IconlyLight.discovery),
    _NavItem(route: AppRoutes.wanted, labelKey: 'wanted', icon: IconlyLight.search),
    _NavItem(route: AppRoutes.post, labelKey: 'post', icon: IconlyLight.plus),
    _NavItem(route: AppRoutes.messages, labelKey: 'messages', icon: IconlyLight.message),
    _NavItem(route: AppRoutes.profile, labelKey: 'profile', icon: IconlyLight.profile),
  ];

  void _onNavigate(String route) {
    if (Get.currentRoute == route) {
      return;
    }
    Get.offAllNamed(route);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1024) {
      return _DesktopShell(
        currentRoute: currentRoute,
        onNavigate: _onNavigate,
        floatingActionButton: floatingActionButton,
        endDrawer: endDrawer,
        child: child,
      );
    }
    if (width >= 600) {
      return _TabletShell(
        currentRoute: currentRoute,
        onNavigate: _onNavigate,
        floatingActionButton: floatingActionButton,
        endDrawer: endDrawer,
        child: child,
      );
    }

    return Scaffold(
      body: child,
      floatingActionButton: floatingActionButton,
      endDrawer: endDrawer,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _navIndex(currentRoute),
        onDestinationSelected: (int index) => _onNavigate(_navItems[index].route),
        destinations: _navItems
            .map(
              (_NavItem item) => NavigationDestination(
                icon: Icon(item.icon),
                label: item.labelKey.tr,
              ),
            )
            .toList(),
      ),
    );
  }
}

class _DesktopShell extends StatelessWidget {
  const _DesktopShell({
    required this.currentRoute,
    required this.onNavigate,
    required this.child,
    this.floatingActionButton,
    this.endDrawer,
  });

  final String currentRoute;
  final void Function(String route) onNavigate;
  final Widget child;
  final Widget? floatingActionButton;
  final Widget? endDrawer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _AppDrawer(currentRoute: currentRoute, onNavigate: onNavigate),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _navIndex(currentRoute),
            extended: true,
            onDestinationSelected: (int index) => onNavigate(_navItems[index].route),
            destinations: _navItems
                .map(
                  (_NavItem item) => NavigationRailDestination(
                    icon: Icon(item.icon),
                    label: Text(item.labelKey.tr),
                  ),
                )
                .toList(),
          ),
          const VerticalDivider(width: 1),
          Expanded(
            child: Scaffold(
              endDrawer: endDrawer,
              floatingActionButton: floatingActionButton,
              body: child,
            ),
          ),
        ],
      ),
    );
  }
}

class _TabletShell extends StatelessWidget {
  const _TabletShell({
    required this.currentRoute,
    required this.onNavigate,
    required this.child,
    this.floatingActionButton,
    this.endDrawer,
  });

  final String currentRoute;
  final void Function(String route) onNavigate;
  final Widget child;
  final Widget? floatingActionButton;
  final Widget? endDrawer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _AppDrawer(currentRoute: currentRoute, onNavigate: onNavigate),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _navIndex(currentRoute),
            labelType: NavigationRailLabelType.none,
            onDestinationSelected: (int index) => onNavigate(_navItems[index].route),
            destinations: _navItems
                .map(
                  (_NavItem item) => NavigationRailDestination(
                    icon: Icon(item.icon),
                    label: Text(item.labelKey.tr),
                  ),
                )
                .toList(),
          ),
          const VerticalDivider(width: 1),
          Expanded(
            child: Scaffold(
              endDrawer: endDrawer,
              floatingActionButton: floatingActionButton,
              body: child,
            ),
          ),
        ],
      ),
    );
  }
}

class _AppDrawer extends StatelessWidget {
  const _AppDrawer({required this.currentRoute, required this.onNavigate});

  final String currentRoute;
  final void Function(String route) onNavigate;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 24),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Text(
                'app_name'.tr,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            for (final item in _navItems)
              ListTile(
                leading: Icon(item.icon),
                title: Text(item.labelKey.tr),
                selected: item.route == currentRoute,
                mouseCursor: MaterialStateMouseCursor.clickable,
                onTap: () {
                  Navigator.of(context).maybePop();
                  onNavigate(item.route);
                },
              ),
          ],
        ),
      ),
    );
  }
}

int _navIndex(String currentRoute) {
  final index = _navItems.indexWhere((_NavItem item) => item.route == currentRoute);
  return index >= 0 ? index : 0;
}

class _NavItem {
  const _NavItem({required this.route, required this.labelKey, required this.icon});

  final String route;
  final String labelKey;
  final IconData icon;
}
