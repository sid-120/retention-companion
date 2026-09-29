import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';
import 'streaks_screen.dart';
import 'success_codex_screen.dart';
import 'jing_screen.dart';
import 'profile_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  final _screens = const [
    HomeScreen(),
    StreaksScreen(),
    SuccessCodexScreen(),
    JingScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_index],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: AppColors.surface,
          indicatorColor: AppColors.primaryStart.withOpacity(0.3),
        ),
        child: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: (i) => setState(() => _index = i),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.timer_outlined), label: "Home"),
            NavigationDestination(icon: Icon(Icons.bar_chart_rounded), label: "Streaks"),
            NavigationDestination(icon: Icon(Icons.menu_book_rounded), label: "Codex"),
            NavigationDestination(icon: Icon(Icons.self_improvement_rounded), label: "Jing"),
            NavigationDestination(icon: Icon(Icons.person_rounded), label: "Profile"),
          ],
        ),
      ),
    );
  }
}
