import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class RelapseResult {
  final bool success;
  final int oldStreakDays;
  final int newStreakDays;
  final int penaltyApplied;
  final String message;

  RelapseResult({
    required this.success,
    required this.oldStreakDays,
    required this.newStreakDays,
    required this.penaltyApplied,
    required this.message,
  });

  factory RelapseResult.fromJson(Map<String, dynamic> json) {
    return RelapseResult(
      success: json['success'] ?? false,
      oldStreakDays: json['old_streak_days'] ?? 0,
      newStreakDays: json['new_streak_days'] ?? 0,
      penaltyApplied: json['penalty_applied'] ?? 0,
      message: json['message'] ?? '',
    );
  }
}

class RelapseService {
  /// Backend के relapse.php को call करता है, age-based penalty apply करके
  /// नई streak days वापस देता है।
  static Future<RelapseResult> recordRelapse(int userId) async {
    final url = Uri.parse("${ApiConfig.baseUrl}/api/relapse.php");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"user_id": userId}),
    );

    final json = jsonDecode(response.body);
    return RelapseResult.fromJson(json);
  }
}
