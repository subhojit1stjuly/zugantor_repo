import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:zugantor_design_system/zugantor_design_system.dart';

const _items = [
  ZDSNavigationItem(
    icon: Icons.home_outlined,
    selectedIcon: Icons.home,
    label: 'Home',
  ),
  ZDSNavigationItem(
    icon: Icons.search,
    selectedIcon: Icons.search,
    label: 'Search',
  ),
  ZDSNavigationItem(
    icon: Icons.shopping_bag_outlined,
    selectedIcon: Icons.shopping_bag,
    label: 'Orders',
  ),
  ZDSNavigationItem(
    icon: Icons.person_outlined,
    selectedIcon: Icons.person,
    label: 'Profile',
  ),
];

/// Stories for [ZDSNavigationBar].
final navigationBarStories = [
  WidgetbookUseCase(
    name: 'Default',
    builder: (context) => _NavBarDemo(),
  ),
];

class _NavBarDemo extends StatefulWidget {
  @override
  State<_NavBarDemo> createState() => _NavBarDemoState();
}

class _NavBarDemoState extends State<_NavBarDemo> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return ZDSNavigationBar(
      currentIndex: _index,
      onDestinationSelected: (i) => setState(() => _index = i),
      items: _items,
    );
  }
}
