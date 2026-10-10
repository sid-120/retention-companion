import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../data/quotes.dart';
import '../data/streak_service.dart';
import '../data/relapse_service.dart';
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
    const int currentUserId = 1; // TODO: असली logged-in user_id यहाँ डालना

    try {
      final result = await RelapseService.recordRelapse(currentUserId);

      if (result.success) {
        final adjustedStart = DateTime.now().subtract(Duration(days: result.newStreakDays));
        await StreakService.setStartDate(adjustedStart);

        setState(() {
          streakStart = adjustedStart;
          _elapsed = DateTime.now().difference(adjustedStart);
        });
      }
    } catch (e) {
      debugPrint("Relapse API failed: $e");
    }
  }

  void _openReflectionSheet(BuildContext context) {
    final controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20, right: 20, top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Today's Reflection",
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                maxLines: 5,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "What's on your mind today?",
                  hintStyle: const TextStyle(color: AppColors.textSecondary),
                  filled: true,
                  fillColor: AppColors.surfaceLight,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: controller.text को reflection.php API के through save करना है
                    Navigator.pop(ctx);
                  },
                  child: const Text("Save Reflection"),
                ),
              ),
            ],
          ),
        );
      },
    );
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
                  onTap: () => _openReflectionSheet(context),
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
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.surface,
            AppColors.surfaceLight.withOpacity(0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFC084FC).withOpacity(0.6), // सॉफ्ट पर्पल नियोन टच
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFC084FC).withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: const Color(0xFF60A5FA).withOpacity(0.1),
            blurRadius: 35,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Column(
        children: [
          // छोटा सा डेकोरेटिव आइकॉन ऊपर
          const Icon(
            Icons.format_quote_rounded,
            color: Color(0xFFC084FC),
            size: 28,
          ),
          const SizedBox(height: 6),
          Text(
            quote,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15.5,
              fontWeight: FontWeight.w500,
              height: 1.5,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
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
          gradient: const LinearGradient(
            colors: [Color(0xFFFF1744), Color(0xFFFF5252)],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFFF8A80), width: 1.5),
          boxShadow: [
            BoxShadow(color: const Color(0xFFFF1744).withOpacity(0.7), blurRadius: 25, spreadRadius: 1),
            BoxShadow(color: const Color(0xFFFF1744).withOpacity(0.3), blurRadius: 40, spreadRadius: 4),
          ],
        ),
        alignment: Alignment.center,
        child: const Text("PANIC BUTTON",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1.5)),
      ),
    );
  }
}
