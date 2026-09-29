import 'dart:async';

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../data/quotes.dart';
import '../data/streak_service.dart';
import '../models/aura_tier.dart';
import '../widgets/aura_avatar.dart';
import '../widgets/week_tracker.dart';
import 'sensei_chat_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime? streakStart;
  final activeDays = [false, false, false, true, true, true, false];

  Timer? _timer;
  Duration _elapsed = Duration.zero;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final start = await StreakService.getStartDate();
    setState(() {
      streakStart = start;
      _elapsed = DateTime.now().difference(start);
      _loading = false;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    if (streakStart == null) return;
    setState(() => _elapsed = DateTime.now().difference(streakStart!));
  }

  Future<void> _relapse() async {
    final newStart = await StreakService.resetStreak();
    setState(() {
      streakStart = newStart;
      _elapsed = Duration.zero;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  int get streakDays => _elapsed.inDays;

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    final tierData = AuraTierData.forDays(streakDays);
    final hours = _elapsed.inHours % 24;
    final minutes = _elapsed.inMinutes % 60;
    final seconds = _elapsed.inSeconds % 60;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          children: [
            WeekTracker(activeDays: activeDays),
            const SizedBox(height: 12),
            AuraAvatar(streakDays: streakDays),
            const SizedBox(height: 8),
            Text("${tierData.label} · DAY $streakDays",
                style: TextStyle(color: tierData.colors.first, fontWeight: FontWeight.bold, letterSpacing: 2, fontSize: 13)),
            const SizedBox(height: 10),
            Text("You've been free for", style: Theme.of(context).textTheme.bodyMedium),
            Text("$streakDays days", style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 30)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16)),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                _timeUnit(hours, "h"), const SizedBox(width: 6),
                _timeUnit(minutes, "m"), const SizedBox(width: 6),
                _timeUnit(seconds, "s"),
              ]),
            ),
            const SizedBox(height: 22),
            _QuoteCenterCard(quote: QuoteEngine.todayQuote()),
            const SizedBox(height: 22),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ActionCircle(
                  gradient: const LinearGradient(colors: [Color(0xFFC084FC), Color(0xFF60A5FA), Color(0xFFFBBF24)]),
                  icon: Icons.auto_awesome_rounded,
                  label: "Sensei",
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SenseiChatScreen())),
                ),
                _ActionCircle(
                  color: AppColors.surfaceLight,
                  icon: Icons.nightlight_round,
                  label: "Reflect",
                  onTap: () {}, // TODO: open reflection entry sheet
                ),
                _ActionCircle(
                  color: AppColors.surfaceLight,
                  icon: Icons.emoji_emotions_outlined,
                  label: "I relapsed",
                  onTap: _relapse,
                ),
              ],
            ),
            const SizedBox(height: 26),
            _PanicButton(onTap: () {}), // TODO: emergency support screen
            const SizedBox(height: 8),
            Text("In case of emergency, press here", style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _timeUnit(int value, String unit) {
    return RichText(
      text: TextSpan(children: [
        TextSpan(text: value.toString().padLeft(2, '0'),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
        TextSpan(text: unit, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
      ]),
    );
  }
}

class _QuoteCenterCard extends StatelessWidget {
  final String quote;
  const _QuoteCenterCard({required this.quote});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient.scale(0.15),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.primaryEnd.withOpacity(0.4)),
      ),
      child: Text(quote, textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500, height: 1.4)),
    );
  }
}

class _ActionCircle extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;
  final Gradient? gradient;
  const _ActionCircle({required this.icon, required this.label, required this.onTap, this.color, this.gradient});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(children: [
        Container(
          width: 58, height: 58,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color, gradient: gradient),
          child: Icon(icon, color: Colors.white, size: 26),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
      ]),
    );
  }
}

class _PanicButton extends StatelessWidget {
  final VoidCallback onTap;
  const _PanicButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.redAccent.withOpacity(0.4)),
        ),
        child: const Center(
          child: Text("PANIC BUTTON", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
        ),
      ),
    );
  }
}
