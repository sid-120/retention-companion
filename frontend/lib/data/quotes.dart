class QuoteEngine {
  static const List<String> _quotes = [
    "Discipline is choosing between what you want now and what you want most.",
    "Your energy is your currency. Spend it wisely.",
    "Every day retained is a day reclaimed.",
    "Stillness is strength in disguise.",
    "You're not restricting yourself — you're rebuilding yourself.",
    "The version of you 90 days from now is watching.",
    "Small wins today, unstoppable momentum tomorrow.",
    "Conserve. Channel. Conquer.",
    "Real power is quiet — it doesn't need to prove itself.",
    "One choice at a time builds the person you're becoming.",
  ];

  /// Deterministic — same quote for everyone on the same calendar day
  static String todayQuote() {
    final dayOfYear = DateTime.now()
        .difference(DateTime(DateTime.now().year, 1, 1))
        .inDays;
    return _quotes[dayOfYear % _quotes.length];
  }
}
