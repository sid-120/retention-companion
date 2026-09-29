import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class WeekTracker extends StatelessWidget {
  final List<bool> activeDays; // length 7 — Mon..Sun
  const WeekTracker({super.key, required this.activeDays});

  static const _labels = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

  @override
  Widget build(BuildContext context) {
    final todayIndex = DateTime.now().weekday - 1;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (i) {
        final isActive = activeDays[i];
        final isToday = i == todayIndex;
        return Column(
          children: [
            Text(_labels[i],
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                  color: isToday ? Colors.white : AppColors.textSecondary,
                )),
            const SizedBox(height: 8),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive ? const Color(0xFF60A5FA) : const Color(0xFF1A1530),
                boxShadow: isActive
                    ? [BoxShadow(color: const Color(0xFF60A5FA).withOpacity(0.5), blurRadius: 10)]
                    : [],
              ),
            ),
          ],
        );
      }),
    );
  }
}
