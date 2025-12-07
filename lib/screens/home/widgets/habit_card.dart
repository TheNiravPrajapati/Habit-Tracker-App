import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/habit_provider.dart';
import '../../../models/habit.dart';

class HabitCard extends StatelessWidget {
  final Habit habit;
  final int index;

  const HabitCard({super.key, required this.habit, required this.index});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HabitProvider>(context, listen: false);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: habit.isCompleted
            ? LinearGradient(
          colors: [
            Colors.teal.shade300,
            Colors.teal.shade500,
          ],
        )
            : LinearGradient(
          colors: [
            Colors.grey.shade200,
            Colors.grey.shade100,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          habit.name,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: habit.isCompleted ? Colors.white : Colors.black87,
          ),
        ),
        subtitle: Text(
          "🔥 Streak: ${habit.streak} days",
          style: TextStyle(
            color: habit.isCompleted ? Colors.white70 : Colors.black54,
          ),
        ),
        trailing: Checkbox(
          value: habit.isCompleted,
          onChanged: (_) => provider.toggleHabitToday(index),
          activeColor: Colors.white,
          checkColor: Colors.teal,
          side: const BorderSide(color: Colors.black54),
        ),
      ),
    );
  }
}
