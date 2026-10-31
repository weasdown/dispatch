/// The middle three hours of a unit's shift (assuming the shift is over 6 hours long).
final class MealBreakWindow {
  const MealBreakWindow({required this.startTime, required this.endTime});

  final DateTime startTime;
  final DateTime endTime;
}
