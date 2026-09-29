import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';

class JingScreen extends StatelessWidget {
  const JingScreen({super.key});

  static const videoUrl =
      "https://www.youtube.com/watch?v=gXEBY3jmqy8&list=PL7TI_fcs9RLxBNdrK5DDEQkIcB08iY2Ns&index=9";

  Future<void> _openVideo() async {
    final uri = Uri.parse(videoUrl);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Understanding Jing", style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 6),
            Text("Your vital essence — decoded",
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 20),

            // Video thumbnail card
            GestureDetector(
              onTap: _openVideo,
              child: Container(
                height: 180,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: Icon(Icons.play_circle_fill_rounded, size: 64, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text("Tap to watch: Semen Retention Timeline Explained",
                  style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
            ),
            const SizedBox(height: 28),

            _section(context, "What is Jing?",
                "In Traditional Chinese Medicine, Jing is your foundational life-force energy — "
                "the essence stored in the kidneys that governs vitality, aging, and reproductive energy. "
                "Unlike Qi (daily energy) which replenishes quickly, Jing is a finite, precious reserve."),

            _section(context, "Why Retention Matters",
                "Every ejaculation draws from your Jing reserves. Practicing retention is believed to "
                "conserve this essence — supporting sustained energy, mental clarity, and long-term vitality "
                "instead of short bursts of depletion."),

            _section(context, "The Three Treasures",
                "Jing (Essence) → Qi (Energy) → Shen (Spirit). Jing is the root. When conserved, it transforms "
                "upward into Qi and Shen — fueling focus, creativity, and presence."),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _section(BuildContext context, String title, String body) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(body, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
