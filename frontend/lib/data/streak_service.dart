import 'package:shared_preferences/shared_preferences.dart';

/// Single source of truth for streak start date.
class StreakService {
  static const _key = 'streak_start_date';

  /// Returns the saved start date. If none exists yet, sets "now" as start.
  static Future<DateTime> getStartDate() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_key);
    if (stored != null) {
      return DateTime.parse(stored);
    }
    final now = DateTime.now();
    await prefs.setString(_key, now.toIso8601String());
    return now;
  }

  /// Call when user taps "I relapsed" — resets the clock to now.
  /// (Local-only reset — ab home_screen.dart ismein use nahi karta,
  /// backend se mile adjusted date ke liye setStartDate() use hota hai.)
  static Future<DateTime> resetStreak() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    await prefs.setString(_key, now.toIso8601String());
    return now;
  }

  /// Backend se mile adjusted date (age-based penalty ke baad) ko
  /// local storage mein save karta hai, taaki app restart hone par
  /// bhi streak wahi rahe.
  static Future<void> setStartDate(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, date.toIso8601String());
  }
}
