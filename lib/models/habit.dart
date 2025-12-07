class Habit {
  String name;
  bool isCompleted;
  int streak;
  DateTime lastCompletedDate;

  /// THIS MUST NEVER BE NULL
  List<String> completedDates;

  Habit({
    required this.name,
    this.isCompleted = false,
    this.streak = 0,
    DateTime? lastCompletedDate,
    List<String>? completedDates,
  })  : lastCompletedDate = lastCompletedDate ?? DateTime.now(),
        completedDates = completedDates ?? [];

  /// Check if a specific date is completed
  bool isDateCompleted(DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day)
        .toIso8601String()
        .substring(0, 10);

    return completedDates.any((d) => d.startsWith(normalized));
  }

  /// Toggle a specific date
  void toggleDate(DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day)
        .toIso8601String()
        .substring(0, 10);

    if (completedDates.any((d) => d.startsWith(normalized))) {
      completedDates.removeWhere((d) => d.startsWith(normalized));
    } else {
      completedDates.add(
        DateTime(date.year, date.month, date.day).toIso8601String(),
      );
    }
  }

  /// Recompute streak
  void recomputeStreak() {
    int count = 0;
    DateTime cursor = DateTime.now();

    while (true) {
      final normalized = DateTime(cursor.year, cursor.month, cursor.day)
          .toIso8601String()
          .substring(0, 10);

      if (completedDates.any((d) => d.startsWith(normalized))) {
        count++;
        cursor = cursor.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }

    streak = count;
    if (completedDates.isNotEmpty) {
      lastCompletedDate = DateTime.parse(completedDates.last);
    }
  }

  /// SAVE
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'isCompleted': isCompleted,
      'streak': streak,
      'lastCompletedDate': lastCompletedDate.toIso8601String(),

      /// MUST BE SAVED
      'completedDates': completedDates,
    };
  }

  /// LOAD
  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      name: map['name'] ?? '',
      isCompleted: map['isCompleted'] ?? false,
      streak: map['streak'] ?? 0,
      lastCompletedDate: map['lastCompletedDate'] != null
          ? DateTime.parse(map['lastCompletedDate'])
          : DateTime.now(),

      /// FIX: If missing → make empty list, not null
      completedDates: map['completedDates'] != null
          ? List<String>.from(map['completedDates'])
          : <String>[],
    );
  }
}
