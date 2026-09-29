import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/main_shell.dart';

void main() {
  runApp(const RetentionCompanionApp());
}

class RetentionCompanionApp extends StatelessWidget {
  const RetentionCompanionApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Retention Companion',
      theme: buildAppTheme(),
      home: const MainShell(),
      debugShowCheckedModeBanner: false,
    );
  }
}
