import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/habit_provider.dart';
import '../../providers/theme_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);

    final data = await auth.loadProfile();

    if (!mounted) return;

    setState(() {
      userData = data;
      isLoading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
          body: Center(child: CircularProgressIndicator()));
    }

    if (userData == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Profile")),
        body: const Center(
            child: Text("Profile not found in Firestore ❌")),
      );
    }

    final habits = Provider.of<HabitProvider>(context).habits;
    final theme = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: Column(
        children: [
          header(),

          const SizedBox(height: 12),

          Text(
            userData!["name"] ?? "User",
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text(
            userData!["email"] ?? "",
            style: TextStyle(color: Colors.grey.shade600),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                statRow(habits),
                const SizedBox(height: 20),
                tile(Icons.edit, "Edit Profile", () async {
                  await Navigator.pushNamed(context, "/edit_profile");
                  loadProfile();
                }),

                tile(Icons.color_lens,
                    "Theme: ${theme.isDark ? "Dark" : "Light"}",
                        () => theme.toggleTheme()),

                tile(Icons.logout, "Logout", () {
                  Provider.of<AuthProvider>(context, listen: false).logout();
                  Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
                }, color: Colors.red),

              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget header() {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.teal.shade300, Colors.teal.shade600])),
      child: const Column(
        children: [
          SizedBox(height: 40),
          CircleAvatar(
            radius: 45,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, size: 50, color: Colors.teal),
          ),
        ],
      ),
    );
  }

  Widget statRow(habits) {
    int total = habits.fold(0, (sum, h) => sum + h.completedDates.length);
    int streak = habits.fold(0, (max, h) => h.streak > max ? h.streak : max);

    return Row(
      children: [
        Expanded(child: statCard("Total", "$total")),
        const SizedBox(width: 12),
        Expanded(child: statCard("Streak", "$streak days")),
      ],
    );
  }

  Widget statCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
              colors: [Colors.teal.shade400, Colors.teal.shade700])),
      child: Column(
        children: [
          Text(label, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  Widget tile(IconData icon, String title, VoidCallback onTap,
      {Color? color}) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: color ?? Colors.teal),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        title: Text(title),
        onTap: onTap,
      ),
    );
  }
}
