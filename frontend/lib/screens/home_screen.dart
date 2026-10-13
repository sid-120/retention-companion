import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../data/quotes.dart';
import '../data/streak_service.dart';
import '../data/relapse_service.dart';
import '../data/reflection_service.dart';
import '../models/aura_tier.dart';
import '../widgets/aura_avatar.dart';
import '../widgets/week_tracker.dart';
import 'sensei_chat_screen.dart';
import 'panic_screen.dart';
import '../widgets/reflect_bottom_sheet.dart';


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

    void _openReflectModal() async {
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const ReflectBottomSheet(),
    );

    if (result == true) {
      setState(() {});
    }
  }

  void _tick() {
    if (streakStart == null) return;
    setState(() => _elapsed = DateTime.now().difference(streakStart!));
  }

  Future<void> _relapse() async {
    const int currentUserId = 1; 

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
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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
                  hintText: "What's on your mind today, Siddharth?",
                  hintStyle: const TextStyle(color: AppColors.textSecondary),
                  filled: true,
                  fillColor: AppColors.surfaceLight,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF60A5FA),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () async {
                    if (controller.text.trim().isNotEmpty) {
                      await ReflectionService.addReflection(controller.text.trim());
                      Navigator.pop(ctx);
                      setState(() {}); 
                    }
                  },
                  child: const Text("Save Reflection", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
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
            // यहाँ अब streakDays पास किया गया है ताकि अवतार डायनेमिक रहे
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
            const SizedBox(height: 26),
            
            // Modern Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ModernActionCard(
                  icon: Icons.auto_awesome_rounded,
                  label: "Sensei",
                  gradient: const LinearGradient(
                    colors: [Color(0xFFC084FC), Color(0xFF818CF8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shadowColor: const Color(0xFFC084FC).withOpacity(0.4),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SenseiChatScreen())),
                ),
                _ModernActionCard(
                  icon: Icons.nightlight_round,
                  label: "Reflect",
                  gradient: const LinearGradient(
                    colors: [Color(0xFF38BDF8), Color(0xFF0284C7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shadowColor: const Color(0xFF38BDF8).withOpacity(0.4),
                  onTap: () => _openReflectionSheet(context),
                ),
                _ModernActionCard(
                  icon: Icons.refresh_rounded,
                  label: "Relapsed",
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFB7185), Color(0xFFE11D48)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shadowColor: const Color(0xFFFB7185).withOpacity(0.4),
                  onTap: _relapse,
                ),
              ],
            ),
            
            const SizedBox(height: 26),
            
            // Modern Emergency / Panic Button
            _ModernPanicButton(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PanicScreen()),
                );
              },
            ),
            
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
          color: const Color(0xFFC084FC).withOpacity(0.6),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFC084FC).withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
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

class _ModernActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Gradient gradient;
  final Color shadowColor;
  final VoidCallback onTap;

  const _ModernActionCard({
    required this.icon,
    required this.label,
    required this.gradient,
    required this.shadowColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: gradient,
              boxShadow: [
                BoxShadow(
                  color: shadowColor,
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// नया Modern Neon Panic / Emergency Button
class _ModernPanicButton extends StatelessWidget {
  final VoidCallback onTap;

  const _ModernPanicButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFE11D48), Color(0xFF9F1239)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.redAccent.withOpacity(0.5),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.2),
              ),
              child: const Icon(
                Icons.warning_amber_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "EMERGENCY / PANIC",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  "In case of emergency, press here",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}