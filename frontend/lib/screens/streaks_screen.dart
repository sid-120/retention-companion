import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/aura_tier.dart';

class StreaksScreen extends StatelessWidget {
  const StreaksScreen({super.key});

  // TODO: replace with real streak history from backend
  static const history = [
    {"days": 31, "start": "12 Aug", "end": "12 Sep", "status": "Relapsed"},
    {"days": 14, "start": "20 Jul", "end": "3 Aug", "status": "Relapsed"},
    {"days": 3, "start": "25 Sep", "end": "Ongoing", "status": "Active"},
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Streaks", style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _statCard(context, "31", "Best Streak")),
                const SizedBox(width: 12),
                Expanded(child: _statCard(context, "3", "Current Streak")),
              ],
            ),
            const SizedBox(height: 24),
            Text("History", style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            ...history.reversed.map((h) => _historyCard(context, h)),
          ],
        ),
      ),
    );
  }

  Widget _statCard(BuildContext context, String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16)),
      alignment: Alignment.center,
      child: Column(children: [
        Text(value, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
      ]),
    );
  }

  Widget _historyCard(BuildContext context, Map<String, Object> h) {
    final days = h["days"] as int;
    final glow = AppColors.glowForDays(days);
    final active = h["status"] == "Active";
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16)),
      child: Row(children: [
        Container(
          width: 50, height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: glow.withOpacity(0.2),
            border: Border.all(color: glow, width: 2),
          ),
          alignment: Alignment.center,
          child: Text("$days", style: TextStyle(color: glow, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${h["start"]} → ${h["end"]}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
              const SizedBox(height: 3),
              Text("$days days", style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
        Text(h["status"] as String,
            style: TextStyle(color: active ? const Color(0xFF4ADE80) : const Color(0xFFF87171), fontSize: 12, fontWeight: FontWeight.w600)),
      ]),
    );
  }
}
