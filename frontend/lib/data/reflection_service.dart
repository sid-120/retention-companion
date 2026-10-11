import 'package:shared_preferences/shared_preferences.dart';

class ReflectionModel {
  final String text;
  final String date;

  ReflectionModel({required this.text, required this.date});

  Map<String, dynamic> toJson() => {'text': text, 'date': date};
  factory ReflectionModel.fromJson(Map<String, dynamic> json) {
    return ReflectionModel(
      text: json['text'] ?? '',
      date: json['date'] ?? '',
    );
  }
}

class ReflectionService {
  static const String _key = 'reflections_list';

  // सभी रिफ़्लेक्शन प्राप्त करें
  static Future<List<ReflectionModel>> getReflections() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? data = prefs.getStringList(_key);
    if (data == null) return [];
    return data.map((str) {
      // सरल फॉर्मेट के लिए स्प्लिट कर सकते हैं या JSON
      final parts = str.split('|||');
      return ReflectionModel(
        text: parts.isNotEmpty ? parts[0] : '',
        date: parts.length > 1 ? parts[1] : '',
      );
    }).toList();
  }

  // नया रिफ़्लेक्शन जोड़ें
  static Future<void> addReflection(String text) async {
    final prefs = await SharedPreferences.getInstance();
    final reflections = await getReflections();
    
    final now = DateTime.now();
    final dateStr = "${now.day} ${_getMonthName(now.month)}";
    
    reflections.insert(0, ReflectionModel(text: text, date: dateStr));
    
    final List<String> encoded = reflections.map((r) => "${r.text}|||${r.date}").toList();
    await prefs.setStringList(_key, encoded);
  }

  static String _getMonthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }
}
