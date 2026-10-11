import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/aura_tier.dart';

class AuraAvatar extends StatefulWidget {
  final int streakDays;
  final String? userName;

  const AuraAvatar({
    super.key,
    required this.streakDays,
    this.userName,
  });

  @override
  State<AuraAvatar> createState() => _AuraAvatarState();
}

class _AuraAvatarState extends State<AuraAvatar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.96, end: 1.04).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tierData = AuraTierData.forDays(widget.streakDays);
    final primaryColor = tierData.colors.isNotEmpty ? tierData.colors.first : const Color(0xFF60A5FA);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ScaleTransition(
          scale: _scaleAnimation,
          child: SizedBox(
            width: 220,
            height: 220,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // आउटर नियोन ग्लो रिंग
                if (tierData.glowRadius > 0)
                  Container(
                    width: tierData.glowRadius * 2,
                    height: tierData.glowRadius * 2,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          primaryColor.withOpacity(tierData.glowOpacity + 0.1),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                
                // पार्टिकल्स इफ़ेक्ट
                CustomPaint(
                  size: const Size(220, 220),
                  painter: _ParticlePainter(
                    count: tierData.particleCount,
                    colors: tierData.colors,
                    seed: widget.streakDays,
                  ),
                ),

                // सराउंडिंग राउंड इनर सर्कल और शैडो अवतार के लिए ब्राइट बैकग्राउंड
                ClipOval(
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      // पीछे ब्राइट बैकग्राउंड ताकि Shadow अवतार एकदम साफ़ दिखे
                      gradient: RadialGradient(
                        colors: [
                          primaryColor.withOpacity(0.35),
                          const Color(0xFF1E293B),
                        ],
                      ),
                      border: Border.all(
                        color: primaryColor.withOpacity(0.9),
                        width: 3.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withOpacity(0.5),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Shadow अवतार इमेज (अगर asset में spark/shadow जो भी है वह सीधे लोड होगा)
                        Image.asset(
                          tierData.assetPath,
                          width: 130,
                          height: 130,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: const Color(0xFF0F172A),
                              child: Icon(
                                Icons.person_rounded,
                                size: 60,
                                color: primaryColor,
                              ),
                            );
                          },
                        ),
                        // लाइट ओवरले ताकि क्लेरिटी और बढ़ जाए
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withOpacity(0.12),
                                Colors.transparent,
                                Colors.black.withOpacity(0.15),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (widget.userName != null) ...[
          const SizedBox(height: 8),
          Text(
            widget.userName!,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ],
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
    final paint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < count; i++) {
      final angle = rand.nextDouble() * 2 * pi;
      final radius = 70.0 + rand.nextDouble() * 25.0;
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);

      paint.color = colors[i % colors.length].withOpacity(0.7);
      canvas.drawCircle(Offset(x, y), 3.0, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
