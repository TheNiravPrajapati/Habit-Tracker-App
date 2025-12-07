import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/habit_provider.dart';
import 'widgets/habit_card.dart';
import 'widgets/add_habit_sheet.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HabitProvider>(context);

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: provider.habits.isEmpty
              ? const Center(child: Text("Add your first habit ✨"))
              : ListView.builder(
            itemCount: provider.habits.length,
            itemBuilder: (context, index) {
              return HabitCard(
                habit: provider.habits[index],
                index: index,
              );
            },
          ),
        ),

        // FAB must be handled in MainShell, but if needed:
        Positioned(
          bottom: 20,
          right: 20,
          child: FloatingActionButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.vertical(top: Radius.circular(24)),
                ),
                builder: (_) => const AddHabitSheet(),
              );
            },
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}
