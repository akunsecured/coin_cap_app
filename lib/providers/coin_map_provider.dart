import 'package:coin_cap_app/models/coin_model.dart';
import 'package:coin_cap_app/services/coin_cap_api.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CoinMapProvider extends ChangeNotifier {
  CoinCapApi api = CoinCapApi();
  Map<String, CoinModel> _coinMap = {};
  List<CoinModel> coinsList = [];
  int loaded = 0;
  final int maxLoaded = 2000;
  bool isLoading = false, isDisposed = false;
  int? _sortColumnIndex;
  bool _sortAscending = false;

  bool get sortAscending => _sortAscending;

  int? get sortColumnIndex => _sortColumnIndex;

  void changeSort(int? columnIndex, bool ascending) {
    _sortColumnIndex = columnIndex;
    _sortAscending = ascending;

    switch (_sortColumnIndex) {
      case 1:
        coinsList
            .sort((coin1, coin2) => _compareString(coin1.name, coin2.name));
        break;
      case 2:
        coinsList.sort(
            (coin1, coin2) => _compareDouble(coin1.priceUsd, coin2.priceUsd));
        break;
      case 3:
        coinsList.sort((coin1, coin2) =>
            _compareDouble(coin1.changePercent24Hr, coin2.changePercent24Hr));
        break;
      default:
        coinsList.sort((coin1, coin2) => _compareInt(coin1.rank, coin2.rank));
    }

    notifyListeners();
  }

  int _compareString(String value1, String value2) =>
      _sortAscending ? value1.compareTo(value2) : value2.compareTo(value1);

  int _compareDouble(double value1, double value2) =>
      _sortAscending ? value1.compareTo(value2) : value2.compareTo(value1);

  int _compareInt(int value1, int value2) =>
      _sortAscending ? value1.compareTo(value2) : value2.compareTo(value1);

  changeLoading() {
    isLoading = !isLoading;
    if (!isDisposed) notifyListeners();
  }

  Future<void> getCoinList({int limit = 40}) async {
    if (loaded != 0) {
      changeLoading();
    }

    await Future.delayed(const Duration(milliseconds: 500));
    final response = await api.getCoins(loaded + limit);

    if (response != null) {
      for (Map<String, dynamic> json in response.data['data']) {
        var coin = CoinModel.fromJson(json);
        _coinMap[coin.id] = coin;
      }
    }

    if (loaded != 0) {
      changeLoading();
    }

    loaded += limit;
    coinsList = _coinMap.values.toList();
    if (!isDisposed) notifyListeners();
  }

  bool isMaxLoaded() => loaded == maxLoaded;

  @override
  void dispose() {
    loaded = 0;
    isDisposed = true;
    super.dispose();
  }
}
