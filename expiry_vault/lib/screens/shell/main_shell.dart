import 'package:flutter/material.dart';

import '../expiring_feed/expiring_soon_screen.dart';
import '../home/home_dashboard_screen.dart';
import '../search/search_filter_screen.dart';
import '../settings/settings_screen.dart';

/// Bottom-nav shell hosting the four top-level destinations. Uses an
/// `IndexedStack` so each tab keeps its scroll position/state when the
/// user switches away and back.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  static const List<Widget> _screens = [
    HomeDashboardScreen(),
    SearchFilterScreen(),
    ExpiringSoonScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (index) => setState(() => _index = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search_rounded), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_rounded), label: 'Expiring'),
          BottomNavigationBarItem(icon: Icon(Icons.settings_rounded), label: 'Settings'),
        ],
      ),
    );
  }
}
