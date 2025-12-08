import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/habit_provider.dart';
import '../achievements/widgets/achievement_badge.dart';
import '../achievements/widgets/achievement_card.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final habits = Provider.of<HabitProvider>(context).habits;

    int totalCompletions =
    habits.fold(0, (sum, h) => sum + h.completedDates.length);
    int bestStreak =
    habits.fold(0, (max, h) => h.streak > max ? h.streak : max);

    return Scaffold(
      appBar: AppBar(title: const Text("Achievements")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Your Achievements",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            // 🥇 Streak Achievements
            AchievementCard(
              title: "Streak Master",
              subtitle: "Reach streak milestones",
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AchievementBadge(
                    label: "3 Days",
                    achieved: bestStreak >= 3,
                  ),
                  AchievementBadge(
                    label: "7 Days",
                    achieved: bestStreak >= 7,
                  ),
                  AchievementBadge(
                    label: "30 Days",
                    achieved: bestStreak >= 30,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 🏅 Completion Achievements
            AchievementCard(
              title: "Habit Milestones",
              subtitle: "Track your progress",
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AchievementBadge(
                    label: "10 Times",
                    achieved: totalCompletions >= 10,
                  ),
                  AchievementBadge(
                    label: "50 Times",
                    achieved: totalCompletions >= 50,
                  ),
                  AchievementBadge(
                    label: "100 Times",
                    achieved: totalCompletions >= 100,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 🎯 Special Achievement
            AchievementCard(
              title: "Special Rewards",
              subtitle: "Unique milestones",
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(
                      habits.isNotEmpty
                          ? Icons.star
                          : Icons.star_border,
                      color: Colors.teal,
                    ),
                    title: const Text("First Habit Added"),
                    subtitle: const Text("Start your journey"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
