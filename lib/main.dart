import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:habit_tracker_app/services/notifications_service.dart';
import 'package:habit_tracker_app/services/timezone_helper.dart';
import 'package:provider/provider.dart';

import 'providers/habit_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/navigation_provider.dart';

import 'screens/splash/splash_screen.dart';
import 'screens/main_shell.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/profile/edit_profile_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'screens/help/help_screen.dart';
import 'screens/achievements/achievements_screen.dart';
import 'screens/notifications/notification_screen.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await TimeZoneHelper.configureLocalTimeZone();
  await NotificationService.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HabitProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, theme, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Habit Tracker",
          theme: theme.isDark ? ThemeData.dark() : ThemeData.light(),
          home: const SplashScreen(),
          routes: {
            "/home": (_) => const MainShell(),
            "/profile": (_) => const ProfileScreen(),
            "/edit_profile": (_) => const EditProfileScreen(),
            "/settings": (_) => const SettingsScreen(),
            "/help": (_) => const HelpScreen(),
            "/login": (_) => const LoginScreen(),
            "/achievements": (_) => const AchievementsScreen(),
            "/notifications": (_) => const NotificationScreen(),
          },
        );
      },
    );
  }
}
