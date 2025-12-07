import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

import '../../providers/habit_provider.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HabitProvider>(context);
    final habits = provider.habits;

    // Dropdown items
    final dropdownItems = <DropdownMenuItem<int>>[
      const DropdownMenuItem(value: -1, child: Text("All Habits")),
      ...List.generate(
        habits.length,
            (i) => DropdownMenuItem(value: i, child: Text(habits[i].name)),
      )
    ];

    /// Events for markers
    final eventsMap = provider.selectedHabitIndex == -1
        ? provider.getAggregateEvents()
        : provider.getEventsForHabit(provider.selectedHabitIndex);

    return Scaffold(
      appBar: AppBar(title: const Text("Calendar")),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// Habit dropdown
            Row(
              children: [
                const Text("View: "),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButton<int>(
                    isExpanded: true,
                    value: provider.selectedHabitIndex,
                    items: dropdownItems,
                    onChanged: (v) {
                      provider.selectHabitForCalendar(v ?? -1);
                    },
                  ),
                )
              ],
            ),

            const SizedBox(height: 16),

            /// Calendar
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: TableCalendar(
                  firstDay: DateTime.utc(2000, 1, 1),
                  lastDay: DateTime.utc(2100, 12, 31),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) {
                    return isSameDay(day, _selectedDay);
                  },

                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },

                  calendarStyle: const CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: Colors.teal,
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                  ),

                  /// ✔ TableCalendar 3.2.0 uses markerBuilder instead of eventLoader
                  calendarBuilders: CalendarBuilders(
                    markerBuilder: (context, day, _) {
                      final dayKey =
                      DateTime(day.year, day.month, day.day);

                      final events = eventsMap[dayKey] ?? [];

                      if (events.isEmpty) return null;

                      return Positioned(
                        bottom: 4,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(
                            events.length,
                                (_) => Container(
                              width: 6,
                              height: 6,
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              decoration: const BoxDecoration(
                                color: Colors.teal,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// Toggle date
            ElevatedButton.icon(
              icon: const Icon(Icons.check),
              label: const Text("Toggle Selected Day"),
              onPressed: () {
                if (_selectedDay == null) return;

                final idx = provider.selectedHabitIndex;

                if (idx == -1) {
                  showModalBottomSheet(
                    context: context,
                    builder: (_) => ListView.builder(
                      itemCount: habits.length,
                      itemBuilder: (context, i) {
                        final h = habits[i];
                        final done = h.isDateCompleted(_selectedDay!);

                        return ListTile(
                          title: Text(h.name),
                          trailing:
                          done ? const Icon(Icons.check) : null,
                          onTap: () {
                            provider.toggleDateForHabit(i, _selectedDay!);
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  );
                } else {
                  provider.toggleDateForHabit(idx, _selectedDay!);
                }
              },
            ),

            const SizedBox(height: 12),

            /// Completed list
            Expanded(
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Completed on ${DateFormat.yMMMd().format(_selectedDay!)}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Expanded(
                        child: Builder(
                          builder: (_) {
                            final items =
                            provider.getCompletedNamesOn(_selectedDay!);

                            if (items.isEmpty) {
                              return const Center(
                                  child: Text("No habits completed"));
                            }

                            return ListView.separated(
                              itemCount: items.length,
                              separatorBuilder: (_, __) => const Divider(),
                              itemBuilder: (context, i) {
                                return ListTile(
                                  title: Text(items[i]),
                                );
                              },
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
