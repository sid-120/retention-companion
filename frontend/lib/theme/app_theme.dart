import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const background = Color(0xFF0E0B1A);
  static const surface = Color(0xFF1A1530);
  static const surfaceLight = Color(0xFF241D3E);
  static const primaryStart = Color(0xFF8B5CF6);
  static const primaryEnd = Color(0xFFC084FC);
  static const textPrimary = Color(0xFFF5F3FF);
  static const textSecondary = Color(0xFFA1A1AA);

  // Streak glow tiers
  static Color glowForDays(int days) {
    if (days >= 90) return const Color(0xFFC084FC); // royal violet
    if (days >= 30) return const Color(0xFFFBBF24); // gold
    if (days >= 7) return const Color(0xFF34D399); // green
    return const Color(0xFF60A5FA); // blue
  }

  static LinearGradient primaryGradient = const LinearGradient(
    colors: [primaryStart, primaryEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

ThemeData buildAppTheme() {
  final base = ThemeData.dark();
  return base.copyWith(
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: base.colorScheme.copyWith(
      primary: AppColors.primaryStart,
      secondary: AppColors.primaryEnd,
      surface: AppColors.surface,
    ),
    textTheme: GoogleFonts.interTextTheme(base.textTheme).copyWith(
      headlineMedium: GoogleFonts.poppins(
        fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.textPrimary,
      ),
      titleLarge: GoogleFonts.poppins(
        fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14, color: AppColors.textSecondary,
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
  );
}
