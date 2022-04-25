enum IntervalEnum {
  d1,
  m1,
  m5,
  m15
}

extension IntervalEnumString on IntervalEnum {
  String getName() => name;
}