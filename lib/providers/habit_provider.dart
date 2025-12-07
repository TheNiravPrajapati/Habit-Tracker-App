import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../data/local_storage.dart';

class HabitProvider extends ChangeNotifier {
  List<Habit> habits = [];
  int selectedHabitIndex = -1; // -1 means "All habits"

  HabitProvider() {
    loadHabits();
  }

  void selectHabitForCalendar(int index) {
    selectedHabitIndex = index;
    notifyListeners();
  }

  void addHabit(String name) {
    habits.add(Habit(name: name));
    saveHabits();
    notifyListeners();
  }

  // Toggle today's completion
  void toggleHabitToday(int index) {
    toggleDateForHabit(index, DateTime.now());
  }

  // Toggle a specific date
  void toggleDateForHabit(int index, DateTime date) {
    final habit = habits[index];

    habit.toggleDate(date);
    habit.recomputeStreak();

    // today completion check
    final today = DateTime.now();
    habit.isCompleted = habit.isDateCompleted(today);

    saveHabits();
    notifyListeners();
  }

  Future<void> saveHabits() async {
    final data = habits.map((h) => h.toMap()).toList();
    await LocalStorage.saveHabits(data);
  }

  Future<void> loadHabits() async {
    final data = await LocalStorage.loadHabits();

    habits = data.map((e) => Habit.fromMap(e)).toList();

    // recompute streaks & isCompleted
    for (var h in habits) {
      h.recomputeStreak();
      h.isCompleted = h.isDateCompleted(DateTime.now());
    }

    notifyListeners();
  }

  // SAFE — never returns null list
  List<String> getCompletedNamesOn(DateTime date) {
    final day = DateTime(date.year, date.month, date.day);

    if (selectedHabitIndex == -1) {
      final events = getAggregateEvents();
      return events[day] ?? <String>[];
    } else {
      final events = getEventsForHabit(selectedHabitIndex);
      return events[day] ?? <String>[];
    }
  }

  // SAFE — never returns null values
  Map<DateTime, List<String>> getEventsForHabit(int index) {
    final Map<DateTime, List<String>> events = {};

    if (index < 0 || index >= habits.length) return events;

    final h = habits[index];

    for (var iso in h.completedDates) {
      final dt = DateTime.parse(iso);
      final day = DateTime(dt.year, dt.month, dt.day);

      events[day] = events[day] ?? <String>[];
      events[day]!.add(h.name);
    }

    return events;
  }

  // SAFE — avoid null values
  Map<DateTime, List<String>> getAggregateEvents() {
    final Map<DateTime, List<String>> events = {};

    for (var h in habits) {
      for (var iso in h.completedDates) {
        final dt = DateTime.parse(iso);
        final day = DateTime(dt.year, dt.month, dt.day);

        events[day] = events[day] ?? <String>[];
        events[day]!.add(h.name);
      }
    }

    return events;
  }
}
