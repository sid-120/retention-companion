import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CodexStage {
  final int number;
  final String title;
  final String subtitle;
  final bool completed;
  final bool locked;
  const CodexStage({required this.number, required this.title, required this.subtitle, this.completed = false, this.locked = false});
}

class SuccessCodexScreen extends StatelessWidget {
  const SuccessCodexScreen({super.key});

  // TODO: replace with real progress data from backend
  static const stages = [
    CodexStage(number: 1, title: "The Awakening", subtitle: "Know your enemy", completed: true),
    CodexStage(number: 2, title: "Urge Surfing", subtitle: "Ride the wave without drowning", completed: true),
    CodexStage(number: 3, title: "The Trigger Map", subtitle: "See the attack coming", completed: true),
    CodexStage(number: 4, title: "The Fortress", subtitle: "Design an environment that protects you", locked: true),
    CodexStage(number: 5, title: "Identity Shift", subtitle: "Stop resisting, start becoming", locked: true),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Success Codex", style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 16),
            _PledgeBanner(onTap: () {}), // TODO: record pledge via backend
            const SizedBox(height: 20),
            ...stages.map((s) => _StageCard(stage: s)),
          ],
        ),
      ),
    );
  }
}

class _PledgeBanner extends StatelessWidget {
  final VoidCallback onTap;
  const _PledgeBanner({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF14532D).withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF22C55E).withOpacity(0.5)),
        ),
        child: const Text("🤝 Take today's pledge — I will stay clean today",
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF4ADE80), fontWeight: FontWeight.w600, fontSize: 14)),
      ),
    );
  }
}

class _StageCard extends StatelessWidget {
  final CodexStage stage;
  const _StageCard({required this.stage});

  @override
  Widget build(BuildContext context) {
    final dimmed = stage.locked;
    return Opacity(
      opacity: dimmed ? 0.45 : 1,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(18)),
        child: Row(children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: dimmed ? Colors.white12 : const Color(0xFF60A5FA),
              borderRadius: BorderRadius.circular(12),
              boxShadow: dimmed ? [] : [BoxShadow(color: const Color(0xFF60A5FA).withOpacity(0.5), blurRadius: 10)],
            ),
            alignment: Alignment.center,
            child: Text("${stage.number}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(stage.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 3),
                Text(stage.subtitle, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
          if (stage.completed)
            const Text("✓ Completed", style: TextStyle(color: Color(0xFF4ADE80), fontWeight: FontWeight.w600, fontSize: 12)),
        ]),
      ),
    );
  }
}
