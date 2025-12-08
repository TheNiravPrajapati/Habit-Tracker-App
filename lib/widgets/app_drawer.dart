import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/auth_provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final auth = Provider.of<AuthProvider>(context);

    return FutureBuilder<Map<String, dynamic>?>(
      future: auth.loadProfile(),
      builder: (context, snap) {
        final name = snap.data?["name"] ?? "User";

        return Drawer(
          child: Column(
            children: [
              // --------------------------------------------------
              // TOP SECTION (NO MORE DrawerHeader → no overflow)
              // --------------------------------------------------
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(
                    top: 40, bottom: 20, left: 16, right: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.teal, Colors.teal.shade400],
                  ),
                ),
                child: SafeArea(
                  bottom: false,
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        child:
                        Icon(Icons.person, size: 50, color: Colors.teal),
                      ),
                      const SizedBox(height: 12),
                      FittedBox(
                        child: Text(
                          name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // --------------------------------------------------
              // NAVIGATION ITEMS
              // --------------------------------------------------
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text("Profile"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, "/profile");
                },
              ),

              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text("Settings"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, "/settings");
                },
              ),

              ListTile(
                leading: const Icon(Icons.emoji_events),
                title: const Text("Achievements"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, "/achievements");
                },
              ),
              ListTile(
                leading: const Icon(Icons.notifications),
                title: const Text("Notifications"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, "/notifications");
                },
              ),
              ListTile(
                leading: const Icon(Icons.help_outline),
                title: const Text("Help & Support"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, "/help");
                },
              ),

              const Spacer(),

              SwitchListTile(
                title: const Text("Dark Mode"),
                value: themeProvider.isDark,
                onChanged: (_) => themeProvider.toggleTheme(),
                secondary: const Icon(Icons.dark_mode),
              ),

              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}
