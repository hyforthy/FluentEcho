import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppShell extends StatelessWidget {
  final Widget child;

  const AppShell({required this.child, super.key});

  int _locationToIndex(String location) {
    if (location.startsWith('/notes')) return 1;
    return 0;
  }

  void _onDestinationSelected(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/');
      case 1:
        context.go('/notes');
    }
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final selectedIndex = _locationToIndex(location);

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) => _onDestinationSelected(context, index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.auto_fix_normal_outlined),
            selectedIcon: Icon(Icons.auto_fix_high),
            label: 'AI助手',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: '笔记本',
          ),
        ],
      ),
    );
  }
}
