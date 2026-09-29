import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/aura_tier.dart';
import '../widgets/aura_avatar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: replace with real user data from backend
    const userName = "Siddharth";
    const streakDays = 3;
    const bestStreak = 31;
    const urgesBeat = 1;
    const notesCount = 21;
    final tierData = AuraTierData.forDays(streakDays);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Profile", style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 12),
            Center(child: AuraAvatar(streakDays: streakDays)),
            const SizedBox(height: 8),
            Center(child: Text(userName, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 22))),
            const SizedBox(height: 8),
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(color: AppColors.surfaceLight, borderRadius: BorderRadius.circular(20)),
                child: Text(tierData.label,
                    style: TextStyle(color: tierData.colors.first, fontWeight: FontWeight.bold, letterSpacing: 1.5, fontSize: 12)),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(18)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _stat("$streakDays", "days"), _divider(),
                  _stat("$bestStreak", "best"), _divider(),
                  _stat("$urgesBeat", "⚔ urges beat"), _divider(),
                  _stat("$notesCount", "notes"),
                ],
              ),
            ),
            const SizedBox(height: 26),
            Text("Reflections", style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {}, // TODO: open new reflection entry
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(18)),
                      alignment: Alignment.center,
                      child: Container(
                        width: 56, height: 56,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF60A5FA),
                          boxShadow: [BoxShadow(color: const Color(0xFF60A5FA).withOpacity(0.5), blurRadius: 14)],
                        ),
                        child: const Icon(Icons.add, color: Colors.white, size: 28),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    height: 150,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(18)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Last reflection", style: TextStyle(color: Color(0xFF60A5FA), fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        Expanded(
                          child: Text(
                            "- work par focus kar raha hu. - har roz 8hrs work karnaa mandatory hai...",
                            style: Theme.of(context).textTheme.bodyMedium,
                            overflow: TextOverflow.fade,
                          ),
                        ),
                        Text("25 Sept", style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 11)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _stat(String value, String label) {
    return Column(children: [
      Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
      const SizedBox(height: 4),
      Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF60A5FA))),
    ]);
  }

  Widget _divider() => Container(width: 1, height: 36, color: Colors.white12);
}
