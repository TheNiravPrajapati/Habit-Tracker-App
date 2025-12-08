import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notifications")),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _notificationTile(
            "Habit Reminder",
            "Don’t forget to drink water 💧",
            "Today, 8:30 PM",
          ),
          _notificationTile(
            "Daily Streak",
            "You're on a 5-day streak! Keep going 🔥",
            "Today, 9:00 AM",
          ),
          _notificationTile(
            "Habit Completed",
            "You completed 'Exercise' 🎉",
            "Yesterday",
          ),
        ],
      ),
    );
  }

  Widget _notificationTile(String title, String body, String time) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.notifications, color: Colors.teal),
        title: Text(title),
        subtitle: Text(body),
        trailing: Text(
          time,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
        ),
      ),
    );
  }
}
