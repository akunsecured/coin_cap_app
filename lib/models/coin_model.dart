class CoinModel {
  String id,
      symbol,
      name,
      supply,
      maxSupply,
      marketCapUsd,
      volumeUsd24Hr,
      vwap24Hr;
  double priceUsd, changePercent24Hr;
  int rank;

  CoinModel(
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

  factory CoinModel.fromJson(Map<String, dynamic> map) {
    return CoinModel(
        map['id'] ?? '',
        int.parse(map['rank'] ?? '0'),
        map['symbol'] ?? '',
        map['name'] ?? '',
        map['supply'] ?? '',
        map['maxSupply'] ?? '',
        map['marketCapUsd'] ?? '',
        map['volumeUsd24Hr'] ?? '',
        double.parse(map['priceUsd'] ?? '0.0'),
        double.parse(map['changePercent24Hr'] ?? '0.0'),
        map['vwap24Hr'] ?? '');
  }

  toMap() => {name: priceUsd};

  @override
  String toString() {
    return """{
      id: $id,
      symbol: $symbol,
      priceUsd: $priceUsd
    }""";
  }
}
