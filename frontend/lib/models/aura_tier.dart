import 'package:flutter/material.dart';

enum AuraTier { shadow, spark, ember, radiant, cosmic }

class AuraTierData {
  final AuraTier tier;
  final String label;
  final String assetPath;
  final List<Color> colors;
  final double glowRadius;
  final double glowOpacity;
  final int particleCount;

  const AuraTierData({
    required this.tier,
    required this.label,
    required this.assetPath,
    required this.colors,
    required this.glowRadius,
    required this.glowOpacity,
    required this.particleCount,
  });

  /// Day-based progression: Day 0-2 = no aura, builds up to Day 90+ = full cosmic aura
  static AuraTierData forDays(int days) {
    if (days >= 90) {
      return const AuraTierData(
        tier: AuraTier.cosmic,
        label: "SENSEI",
        assetPath: "assets/avatars/cosmic.png",
        colors: [Color(0xFFC084FC), Color(0xFF60A5FA), Color(0xFFFBBF24), Color(0xFFF472B6)],
        glowRadius: 90,
        glowOpacity: 0.65,
        particleCount: 40,
      );
    } else if (days >= 30) {
      return const AuraTierData(
        tier: AuraTier.radiant,
        label: "RADIANT",
        assetPath: "assets/avatars/radiant.png",
        colors: [Color(0xFFFBBF24), Color(0xFFC084FC)],
        glowRadius: 70,
        glowOpacity: 0.55,
        particleCount: 26,
      );
    } else if (days >= 7) {
      return const AuraTierData(
        tier: AuraTier.ember,
        label: "EMBER",
        assetPath: "assets/avatars/ember.png",
        colors: [Color(0xFF34D399), Color(0xFF60A5FA)],
        glowRadius: 55,
        glowOpacity: 0.45,
        particleCount: 16,
      );
    } else if (days >= 3) {
      return const AuraTierData(
        tier: AuraTier.spark,
        label: "SPARK",
        assetPath: "assets/avatars/spark.png",
        colors: [Color(0xFF60A5FA)],
        glowRadius: 38,
        glowOpacity: 0.35,
        particleCount: 8,
      );
    }
    return const AuraTierData(
      tier: AuraTier.shadow,
      label: "SHADOW",
      assetPath: "assets/avatars/shadow.png",
      colors: [Color(0xFF1E1B2E)],
      glowRadius: 0,
      glowOpacity: 0,
      particleCount: 2,
    );
  }
}
