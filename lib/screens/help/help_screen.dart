import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Help & Support"),
        elevation: 0,
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          _header(),

          const SizedBox(height: 20),

          const Text(
            "How can we help you?",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          Text(
            "Browse FAQs or reach out to our support team.",
            style: TextStyle(color: Colors.grey.shade600),
          ),

          const SizedBox(height: 20),

          _contactCard(),

          const SizedBox(height: 20),

          const Text(
            "Frequently Asked Questions",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          _faq("How do I add a habit?",
              "Go to the Home screen and tap the + button to create a new habit."),

          _faq("Why is my streak not updating?",
              "Streak increases only when you mark a habit as completed for the day."),

          _faq("How do I switch between dark and light theme?",
              "Open Settings → Toggle Dark Mode."),

          _faq("Is my data synced across devices?",
              "Yes, all your progress is securely synced to your account."),

          _faq("How do I reset my password?",
              "Go to the Login page and tap 'Forgot Password'."),
        ],
      ),
    );
  }

  // 📌 Gradient Header
  Widget _header() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.teal.shade400, Colors.teal.shade600],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: const [
          Icon(Icons.support_agent, size: 60, color: Colors.white),
          SizedBox(height: 10),
          Text(
            "Support Center",
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height: 5),
          Text(
            "We're here to help you succeed.",
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  // 📌 Contact card
  Widget _contactCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 1,
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.email, color: Colors.teal),
            title: const Text("Email Support"),
            subtitle: const Text("support@habittracker.app"),
            onTap: () {
              // integrate email launcher later
            },
          ),
          const Divider(height: 0),
          ListTile(
            leading: const Icon(Icons.chat, color: Colors.teal),
            title: const Text("Live Chat"),
            subtitle: const Text("Chat with our support team"),
            onTap: () {
              // live chat page later
            },
          ),
        ],
      ),
    );
  }

  // 📌 FAQ Tile with animation
  Widget _faq(String question, String answer) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        leading: const Icon(Icons.help_outline),
        title: Text(
          question,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(answer, style: const TextStyle(color: Colors.grey)),
          )
        ],
      ),
    );
  }
}
