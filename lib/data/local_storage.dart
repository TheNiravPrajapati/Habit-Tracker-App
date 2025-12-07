import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const _key = 'habits';

  static Future<void> saveHabits(List<Map<String, dynamic>> habits) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = habits.map((e) => jsonEncode(e)).toList();
    await prefs.setStringList(_key, jsonList);
  }

  static Future<List<Map<String, dynamic>>> loadHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_key);

    if (jsonList == null) return [];

    return jsonList
        .map((e) => jsonDecode(e) as Map<String, dynamic>)
        .toList();
  }
}
