final class TimeWindow {
  const TimeWindow({required this.startTime, required this.endTime});

  final DateTime startTime;
  final DateTime endTime;

  bool withinWindow(DateTime time) {
    final bool afterStart =
        time.isAfter(startTime) || time.isAtSameMomentAs(startTime);
    final bool beforeEnd =
        time.isBefore(endTime) || time.isAtSameMomentAs(endTime);
    return afterStart && beforeEnd;
  }
}

/// The middle three hours of a unit's shift (assuming the shift is over 6 hours long).
final class MealBreakWindow extends TimeWindow {
  const MealBreakWindow({required super.startTime, required super.endTime});

  TimeWindow get firstHour => TimeWindow(
    startTime: startTime,
    endTime: startTime.add(Duration(hours: 1)),
  );

  MealBreakWindowHour hourAtTime(DateTime time) {
    if (!withinWindow(time)) {
      return MealBreakWindowHour.notInWindow;
    } else if (inFirstHour(time)) {
      return MealBreakWindowHour.firstHour;
    } else if (inSecondHour(time)) {
      return MealBreakWindowHour.secondHour;
    } else {
      // in third hour
      return MealBreakWindowHour.thirdHour;
    }
  }

  bool inFirstHour(DateTime time) => firstHour.withinWindow(time);

  bool inSecondHour(DateTime time) => secondHour.withinWindow(time);

  bool inThirdHour(DateTime time) => thirdHour.withinWindow(time);

  TimeWindow get secondHour => TimeWindow(
    startTime: startTime.add(Duration(hours: 1)),
    endTime: startTime.add(Duration(hours: 2)),
  );

  TimeWindow get thirdHour => TimeWindow(
    startTime: startTime.add(Duration(hours: 2)),
    endTime: endTime,
  );
}

enum MealBreakWindowHour { firstHour, secondHour, thirdHour, notInWindow }
