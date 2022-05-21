class Currency {
  final String? id, symbol, name;
  final int rank;
  final double supply,
      maxSupply,
      marketCapUsd,
      volumeUsd24Hr,
      priceUsd,
      changePercent24Hr,
      vwap24Hr;

  Currency(
      this.id,
      this.rank,
      this.symbol,
      this.name,
      this.supply,
      this.maxSupply,
      this.marketCapUsd,
      this.volumeUsd24Hr,
      this.priceUsd,
      this.changePercent24Hr,
      this.vwap24Hr);

  factory Currency.fromJson(Map<String, dynamic> json) => Currency(
      json['id'],
      int.parse(json['rank']),
      json['symbol'],
      json['name'],
      json['supply'] == null ? 0.0 : double.parse(json['supply']),
      json['maxSupply'] == null ? 0.0 : double.parse(json['maxSupply']),
      json['marketCapUsd'] == null ? 0.0 : double.parse(json['marketCapUsd']),
      json['volumeUsd24Hr'] == null ? 0.0 : double.parse(json['volumeUsd24Hr']),
      json['priceUsd'] == null ? 0.0 : double.parse(json['priceUsd']),
      json['changePercent24Hr'] == null
          ? 0.0
          : double.parse(json['changePercent24Hr']),
      json['vwap24Hr'] == null ? 0.0 : double.parse(json['vwap24Hr']));
}
