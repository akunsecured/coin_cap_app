import 'package:coin_cap_app/models/date_interval.dart';

extension MyNumExtension on num {
  int length() => round().toString().length;
}

extension MyDoubleExtension on double {
  double roundToDigits(int digits) {
    return double.parse(toStringAsFixed(digits));
  }

  String toFormatted() {
    if (abs() < 10e2) {
      return roundToDigits(2).toString();
    }
    if (abs() < 10e5) {
      return '${(this / 10e2).roundToDigits(2)}k';
    }
    if (abs() < 10e8) {
      return '${(this / 10e5).roundToDigits(2)}m';
    }
    return '${(this / 10e8).roundToDigits(2)}b';
  }
}

extension IntervalEnumExtension on IntervalEnum {
  String asString() {
    switch (index) {
      case 0:
        return 'D1';

      case 1:
        return 'M1';

      default:
        return 'Y1';
    }
  }
}
