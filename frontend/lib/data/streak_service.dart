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
  static Future<DateTime> resetStreak() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    await prefs.setString(_key, now.toIso8601String());
    return now;
  }
}
