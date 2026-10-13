import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../data/reflection_service.dart';

class ReflectBottomSheet extends StatefulWidget {
  const ReflectBottomSheet({super.key});

  @override
  State<ReflectBottomSheet> createState() => _ReflectBottomSheetState();
}

class _ReflectBottomSheetState extends State<ReflectBottomSheet> {
  final TextEditingController _controller = TextEditingController();
  bool _isSaving = false;

  Future<void> _saveReflection() async {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please write something before saving!")),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      await ReflectionService.addReflection(text);

      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Reflection saved successfully! ✨"),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isSaving = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to save: $e"), backgroundColor: Colors.red),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Daily Reflection",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded, color: Colors.white60),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            "What triggered the urge today or what is on your mind?",
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            maxLines: 4,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Write your thoughts here...",
              hintStyle: const TextStyle(color: Colors.white38),
              filled: true,
              fillColor: const Color(0xFF0F172A),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Color(0xFF60A5FA), width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder( // <--- यहाँ सही नाम कर दिया गया है
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: _isSaving ? null : _saveReflection,
              child: _isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : const Text(
                      "Save Reflection",
                      style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                    ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
