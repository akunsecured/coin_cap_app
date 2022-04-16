import 'dart:math';

extension NumberRounding on double {
  double roundToDigits(int digits) {
    var mod = pow(10.0, digits);
    return ((this * mod).round().toDouble() / mod);
  }
}
