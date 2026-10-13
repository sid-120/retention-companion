import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ReflectionModel {
  final String text;
  final String date;

  ReflectionModel({required this.text, required this.date});

  Map<String, dynamic> toJson() => {
        'text': text,
        'date': date,
      };

  factory ReflectionModel.fromJson(Map<String, dynamic> json) => ReflectionModel(
        text: json['text'] ?? '',
        date: json['date'] ?? '',
      );
}

class ReflectionService {
  static const String _key = 'user_reflections_list';

  // सभी रिफ्लेक्शन्स लोड करें
  static Future<List<ReflectionModel>> getReflections() async {
    final prefs = await SharedPreferences.getInstance();
    final String? dataString = prefs.getString(_key);
    if (dataString == null) return [];

    try {
      final List decoded = jsonDecode(dataString);
      return decoded.map((item) => ReflectionModel.fromJson(item)).toList();
    } catch (e) {
      return [];
    }
  }

  // नया रिफ्लेक्शन जोड़ें और सेव करें
  static Future<void> addReflection(String text) async {
    final prefs = await SharedPreferences.getInstance();
    final currentList = await getReflections();

    // वर्तमान तारीख और समय फॉर्मेट करें (जैसे: "28 Sept, 04:30 PM")
    final now = DateTime.now();
    final months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sept", "Oct", "Nov", "Dec"];
    final dateStr = "${now.day} ${months[now.month - 1]}";

    final newEntry = ReflectionModel(text: text, date: dateStr);
    currentList.insert(0, newEntry); // सबसे ऊपर नया जोड़ें

    final encoded = jsonEncode(currentList.map((e) => e.toJson()).toList());
    await prefs.setString(_key, encoded);
  }
}
