import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/aura_tier.dart';
import '../widgets/aura_avatar.dart';
import '../data/reflection_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<ReflectionModel> _reflections = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadReflections();
  }

  Future<void> _loadReflections() async {
    final list = await ReflectionService.getReflections();
    setState(() {
      _reflections = list;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // होमपेज के बिल्कुल अनुरूप सही वैल्यूज और स्ट्रीक
    const userName = "Siddharth";
    const streakDays = 3; 
    const bestStreak = 31;
    const urgesBeat = 1;
    
    final tierData = AuraTierData.forDays(streakDays);
    final lastReflection = _reflections.isNotEmpty ? _reflections.first : null;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Profile",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
            ),
            const SizedBox(height: 16),
            
            // होमपेज की तरह बिल्कुल सही ओरिजिनल AuraAvatar (जो सीधे tierData के हिसाब से सही asset लोड करेगा)
            const Center(child: AuraAvatar(streakDays: streakDays)),
            const SizedBox(height: 8),
            
            Center(
              child: Text(
                userName,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const SizedBox(height: 8),
            
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  tierData.label,
                  style: TextStyle(
                    color: tierData.colors.first,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // स्टैट्स बार (Current Streak, Best, Urges)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.white10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _stat("$streakDays", "Current Streak"),
                  _divider(),
                  _stat("$bestStreak", "Best Streak"),
                  _divider(),
                  _stat("$urgesBeat", "Urges Beat"),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // रिफ्लेक्शन और लास्ट नोट कार्ड्स (ओरिजिनल लेआउट)
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 150,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Total Reflections",
                          style: TextStyle(
                            color: Color(0xFF60A5FA),
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "${_reflections.length}",
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          "Saved entries",
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    height: 150,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Last reflection",
                          style: TextStyle(
                            color: Color(0xFF60A5FA),
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Expanded(
                          child: Text(
                            lastReflection != null
                                ? lastReflection.text
                                : "No reflections yet. Tap Reflect on home!",
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12),
                            overflow: TextOverflow.fade,
                          ),
                        ),
                        Text(
                          lastReflection != null ? lastReflection.date : "",
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Reset Streak Button (प्रीमियम और साफ़-सुथरा)
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.redAccent,
                  side: BorderSide(color: Colors.redAccent.withOpacity(0.4)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () {
                  // Reset streak action
                },
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text(
                  "Reset Streak / Data",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _stat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF60A5FA),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _divider() => Container(width: 1, height: 36, color: Colors.white12);
}
