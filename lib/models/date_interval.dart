class DateInterval {
  final String interval;
  final int start, end;

  DateInterval(this.interval, this.start, this.end);

  factory DateInterval.fromIntervalEnum(IntervalEnum intervalEnum) {
    DateTime end = DateTime.now();
    DateTime start;
    String interval;

    switch (intervalEnum.index) {
      case 0:
        interval = 'm5';
        start = end.subtract(const Duration(days: 1));
        break;
      case 1:
        interval = 'h12';
        start = end.subtract(const Duration(days: 31));
        break;
      default:
        interval = 'd1';
        start = end.subtract(const Duration(days: 365));
    }

    return DateInterval(
        interval, start.millisecondsSinceEpoch, end.millisecondsSinceEpoch);
  }
}

enum IntervalEnum { oneDay, oneMonth, oneYear }
