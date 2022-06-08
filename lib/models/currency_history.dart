class CurrencyHistory {
  final double priceUsd;
  final int time;
  final DateTime? date;

  CurrencyHistory(this.priceUsd, this.time, this.date);

  factory CurrencyHistory.fromJson(Map<String, dynamic> json) =>
      CurrencyHistory(
          json['priceUsd'] == null ? 0.0 : double.parse(json['priceUsd']),
          json['time'] ?? 0,
          DateTime.tryParse(json['date']));
}
