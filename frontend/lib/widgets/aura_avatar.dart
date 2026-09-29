import 'dart:math';
import 'package:flutter/material.dart';
import '../models/aura_tier.dart';

class AuraAvatar extends StatelessWidget {
  final int streakDays;
  const AuraAvatar({super.key, required this.streakDays});

  @override
  Widget build(BuildContext context) {
    final tierData = AuraTierData.forDays(streakDays);
    return SizedBox(
      width: 260,
      height: 260,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (tierData.glowRadius > 0)
            Container(
              width: tierData.glowRadius * 2,
              height: tierData.glowRadius * 2,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    tierData.colors.first.withOpacity(tierData.glowOpacity),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          CustomPaint(
            size: const Size(260, 260),
            painter: _ParticlePainter(
              count: tierData.particleCount,
              colors: tierData.colors,
              seed: streakDays,
            ),
          ),
          Image.asset(
            tierData.assetPath,
            width: 190,
            height: 190,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}

class _ParticlePainter extends CustomPainter {
  final int count;
  final List<Color> colors;
  final int seed;
  _ParticlePainter({required this.count, required this.colors, required this.seed});

  @override
  void paint(Canvas canvas, Size size) {
    final rand = Random(seed);
    final center = Offset(size.width / 2, size.height / 2);
    for (int i = 0; i < count; i++) {
      final angle = rand.nextDouble() * 2 * pi;
      final radius = 60 + rand.nextDouble() * 70;
      final dx = center.dx + radius * cos(angle);
      final dy = center.dy + radius * sin(angle);
      final color = colors[rand.nextInt(colors.length)];
      final paint = Paint()..color = color.withOpacity(0.3 + rand.nextDouble() * 0.5);
      canvas.drawCircle(Offset(dx, dy), 1.5 + rand.nextDouble() * 2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) => false;
}
