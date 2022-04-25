import 'dart:async';
import 'dart:convert';

import 'package:coin_cap_app/models/coin_model.dart';
import 'package:coin_cap_app/services/coin_cap_api.dart';
import 'package:coin_cap_app/utils/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class CoinMapProvider extends ChangeNotifier {
  final CoinCapApi api = CoinCapApi();
  final Map<String, CoinModel> _coinMap = {};
  List<CoinModel> _coinsList = [];
  int loaded = Constants.loadingLimit;
  bool isLoading = false, isDisposed = false;
  int? _sortColumnIndex;
  bool _sortAscending = true;
  WebSocketChannel? _channel;
  StreamSubscription? _streamSubscription;

  List<CoinModel> get coinsList => _coinsList.take(loaded).toList();
  bool get sortAscending => _sortAscending;
  int? get sortColumnIndex => _sortColumnIndex;

  void changeSort({int? columnIndex = 0, bool ascending = true}) {
    _sortColumnIndex = columnIndex;
    _sortAscending = ascending;

    switch (_sortColumnIndex) {
      case 1:
        _coinsList
            .sort((coin1, coin2) => _compareString(coin1.name, coin2.name));
        break;
      case 2:
        _coinsList.sort(
            (coin1, coin2) => _compareDouble(coin1.priceUsd, coin2.priceUsd));
        break;
      case 3:
        _coinsList.sort((coin1, coin2) =>
            _compareDouble(coin1.changePercent24Hr, coin2.changePercent24Hr));
        break;
      default:
        _coinsList.sort((coin1, coin2) => _compareInt(coin1.rank, coin2.rank));
    }

    if (!isDisposed) notifyListeners();
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

  startWebSocketStream() {
    _channel = WebSocketChannel.connect(
      Uri.parse('wss://ws.coincap.io/prices?assets=ALL')
    );
    _streamSubscription = _channel!.stream
        .listen((value) {
          Map<String, dynamic> idPriceMap = jsonDecode(value);
          for (var id in idPriceMap.keys) {
            if (_coinMap.containsKey(id)) {
              _coinMap[id]?.priceUsd = double.parse(idPriceMap[id]!);
            }
          }
          _coinsList = _coinMap.values.toList();
          changeSort(columnIndex: _sortColumnIndex, ascending: _sortAscending);
        });
  }

  Future<void> getCoinList() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final response = await api.getCoins();

    if (response != null) {
      for (Map<String, dynamic> json in response.data['data']) {
        var coin = CoinModel.fromJson(json);
        _coinMap[coin.id] = coin;
      }
      _coinsList = _coinMap.values.toList();
    }
    if (!isDisposed) notifyListeners();
    startWebSocketStream();
  }

  Future<void> loadMore() async {
    changeLoading();
    await Future.delayed(const Duration(milliseconds: 1000));
    loaded += Constants.loadingLimit;
    changeLoading();
  }

  bool isMaxLoaded() => loaded == Constants.maxLimit;

  @override
  void dispose() {
    _streamSubscription?.cancel();
    _channel?.sink.close();
    loaded = Constants.loadingLimit;
    _coinMap.clear();
    _coinsList.clear();
    isDisposed = true;
    super.dispose();
  }
}
