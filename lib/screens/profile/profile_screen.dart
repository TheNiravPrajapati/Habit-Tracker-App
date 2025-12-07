import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/habit_provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/navigation_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final habits = Provider.of<HabitProvider>(context).habits;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final auth = Provider.of<AuthProvider>(context, listen: false);

    int totalCompletions = habits.fold(0, (sum, h) => sum + h.completedDates.length);
    int bestStreak = habits.fold(0, (max, h) => h.streak > max ? h.streak : max);

    return FutureBuilder<Map<String, dynamic>?>(
      future: auth.loadUserProfile(),  // 🔥 FIX — async call outside build()
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final profile = snapshot.data!;
        final String username = profile["name"] ?? "User";
        final String email = profile["email"] ?? "No Email";

        return Scaffold(
          body: Column(
            children: [
              _buildHeader(context),
              const SizedBox(height: 16),

              Text(
                username,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),

              Text(
                email,
                style: const TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 20),

              /// Stats Cards
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(child: _statCard("Total Completions", "$totalCompletions")),
                    const SizedBox(width: 12),
                    Expanded(child: _statCard("Best Streak", "$bestStreak days")),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// Options
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _optionTile(Icons.edit, "Edit Profile", () {}),
                    _optionTile(Icons.lock, "Change Password", () {}),
                    _optionTile(Icons.color_lens,
                        "Theme: ${themeProvider.isDark ? "Dark" : "Light"}", () {
                          themeProvider.toggleTheme();
                        }),
                    _optionTile(Icons.help_outline, "Help & Support", () {
                      Navigator.pushNamed(context, "/help");
                    }),
                    _optionTile(Icons.logout, "Logout", () async {
                      await auth.logout();
                      Navigator.pushReplacementNamed(context, "/login");
                    }, color: Colors.red),
                  ],
                ),
              )
            ],
          ),

          /// 🔥 BOTTOM NAVIGATION
          bottomNavigationBar: Consumer<NavigationProvider>(
            builder: (context, nav, _) {
              return NavigationBar(
                selectedIndex: nav.currentIndex,
                onDestinationSelected: (i) {
                  nav.setIndex(i);
                  Navigator.pop(context);
                },
                destinations: const [
                  NavigationDestination(icon: Icon(Icons.home), label: "Home"),
                  NavigationDestination(icon: Icon(Icons.calendar_month), label: "Calendar"),
                  NavigationDestination(icon: Icon(Icons.bar_chart), label: "Stats"),
                ],
              );
            },
          ),
        );
      },
    );
  }

  /// Header
  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.teal.shade300, Colors.teal.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 40),
          CircleAvatar(
            radius: 45,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, size: 50, color: Colors.teal.shade600),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  /// Stats card
  Widget _statCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: [Colors.teal.shade400, Colors.teal.shade700],
        ),
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }

  /// List tile
  Widget _optionTile(IconData icon, String title, VoidCallback onTap, {Color? color}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      child: ListTile(
        leading: Icon(icon, color: color ?? Colors.teal),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
