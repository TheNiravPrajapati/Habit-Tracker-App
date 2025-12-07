import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/habit_provider.dart';
import '../providers/navigation_provider.dart';
import '../widgets/app_drawer.dart';
import 'home/home_screen.dart';
import 'calendar/calendar_screen.dart';
import 'stats/stats_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      const HomeScreen(),
      const CalendarScreen(),
      const StatsScreen(),
    ];
    final nav = Provider.of<NavigationProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Habit Tracker"),
      ),

      drawer: const AppDrawer(),   // ALWAYS AVAILABLE

      body: screens[nav.currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: nav.currentIndex,
        onDestinationSelected: (i) => nav.setIndex(i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: "Home"),
          NavigationDestination(icon: Icon(Icons.calendar_month), label: "Calendar"),
          NavigationDestination(icon: Icon(Icons.bar_chart), label: "Stats"),
        ],
      ),

    );
  }
}
