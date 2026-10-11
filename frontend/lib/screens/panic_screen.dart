import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PanicScreen extends StatefulWidget {
  const PanicScreen({super.key});

  @override
  State<PanicScreen> createState() => _PanicScreenState();
}

class _PanicScreenState extends State<PanicScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  
  String _breathText = "Breathe In...";
  int _cycleCount = 0;
  final int _maxCycles = 5; // कुल 5 चक्र
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    
    // एक चक्र कुल 30 सेकंड का होगा:
    // 0 से 10 सेकंड (In): 1.0 से 1.8 बड़ा होना
    // 10 से 20 सेकंड (Hold): 1.8 पर स्थिर रहना
    // 20 से 30 सेकंड (Out): 1.8 से वापस 1.0 छोटा होना
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    );

    // सटीक सिंक के साथ 30-सेकंड का सीक्वेंस
    _animation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.8).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 33.3, // Breathe In (10 सेकंड)
      ),
      TweenSequenceItem(
        tween: ConstantTween<double>(1.8),
        weight: 33.3, // Hold (10 सेकंड)
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.8, end: 1.0).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 33.3, // Breathe Out (10 सेकंड)
      ),
    ]).animate(_controller);

    // समय के अनुसार बिल्कुल सटीक टेक्स्ट बदलना (हर 10 सेकंड पर)
    _controller.addListener(() {
      final val = _controller.value;
      if (val < 0.33) {
        if (_breathText != "Breathe In...") {
          setState(() => _breathText = "Breathe In...");
        }
      } else if (val >= 0.33 && val < 0.66) {
        if (_breathText != "Hold...") {
          setState(() => _breathText = "Hold...");
        }
      } else {
        if (_breathText != "Breathe Out...") {
          setState(() => _breathText = "Breathe Out...");
        }
      }
    });

    // चक्र गिनना और 5 चक्र पूरे होने पर रोकना
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _cycleCount++;
          if (_cycleCount >= _maxCycles) {
            _isCompleted = true;
            _controller.stop();
          } else {
            _controller.forward(from: 0.0);
          }
        });
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // ऊपर का हिस्सा (Exit Button & Title)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white, size: 28),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text(
                    "EMERGENCY PROTOCOL",
                    style: TextStyle(
                      color: Color(0xFFFF5252),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),

              // बीच का हिस्सा (Breathing Circle या Completion Message)
              _isCompleted
                  ? Column(
                      children: [
                        const Icon(Icons.check_circle_rounded, color: Color(0xFF4ADE80), size: 80),
                        const SizedBox(height: 16),
                        const Text(
                          "You did great!",
                          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "The intense urge has passed. You are stronger than your impulses.",
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4ADE80),
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Return to Home", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        const Text(
                          "This urge will pass.",
                          style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Round ${_cycleCount + 1} of $_maxCycles · 30s per cycle",
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40),

                        // Animated Glowing Breath Circle (30-second synchronized)
                        Center(
                          child: SizedBox(
                            height: 240,
                            width: 240,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                ScaleTransition(
                                  scale: _animation,
                                  child: Container(
                                    height: 140,
                                    width: 140,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: const LinearGradient(
                                        colors: [Color(0xFFFF1744), Color(0xFFC084FC)],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFFFF1744).withOpacity(0.5),
                                          blurRadius: 45,
                                          spreadRadius: 12,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 130,
                                  width: 130,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.surface,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    _breathText,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

              // नीचे का हिस्सा (Grounding Tip)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFFF5252).withOpacity(0.3)),
                ),
                child: const Column(
                  children: [
                    Text(
                      "⚡ Grounding Tip",
                      style: TextStyle(color: Color(0xFFFF5252), fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "Put your phone down. Stand up, drink a glass of cold water, and do 10 push-ups right now.",
                      style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
