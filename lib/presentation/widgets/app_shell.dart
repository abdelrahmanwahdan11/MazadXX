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
    final isWide = MediaQuery.of(context).size.width >= 900;
    if (isWide) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (int index) => _onNavigate(_navItems[index].route),
              labelType: NavigationRailLabelType.selected,
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

    return Scaffold(
      body: child,
      floatingActionButton: floatingActionButton,
      endDrawer: endDrawer,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
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

  int get _selectedIndex {
    final index = _navItems.indexWhere((_NavItem item) => item.route == currentRoute);
    return index >= 0 ? index : 0;
  }
}

class _NavItem {
  const _NavItem({required this.route, required this.labelKey, required this.icon});

  final String route;
  final String labelKey;
  final IconData icon;
}
