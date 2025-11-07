import 'package:flutter/material.dart';

import '../../core/l10n.dart';
import 'cart_page.dart';
import 'designer_page.dart';
import 'home_page.dart';
import 'specials_page.dart';

class ShellPage extends StatefulWidget {
  const ShellPage({super.key});

  static const routeName = '/';

  @override
  State<ShellPage> createState() => _ShellPageState();
}

class _ShellPageState extends State<ShellPage> {
  int _index = 0;

  final _pages = const [
    HomePage(),
    DesignerPage(),
    SpecialsPage(),
    CartPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: IndexedStack(
          key: ValueKey(_index),
          index: _index,
          children: _pages,
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) {
          setState(() => _index = value);
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: strings.t('navHome'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.local_pizza_outlined),
            selectedIcon: const Icon(Icons.local_pizza),
            label: strings.t('navDesigner'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.local_fire_department_outlined),
            selectedIcon: const Icon(Icons.local_fire_department),
            label: strings.t('navSpecials'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.shopping_bag_outlined),
            selectedIcon: const Icon(Icons.shopping_bag),
            label: strings.t('navCart'),
          ),
        ],
      ),
    );
  }
}
