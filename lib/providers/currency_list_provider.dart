import 'dart:async';

import 'package:coin_cap_app/models/currency.dart';
import 'package:coin_cap_app/services/coin_cap_service.dart';
import 'package:coin_cap_app/utils/constants.dart';
import 'package:coin_cap_app/utils/errors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CurrencyListProvider extends ChangeNotifier {
  final CoinCapService coinCapService = CoinCapService();
  final List<Currency> _currenciesList = [];
  late int loaded;
  bool isLoading = false,
      isLoadingMore = false,
      isDisposed = false,
      _sortAscending = true;
  int? _sortColumnIndex;
  String? error;

  CurrencyListProvider() {
    getCurrenciesList();
  }

  List<Currency> get currenciesList => _currenciesList.take(loaded).toList();

  bool isMaxLoaded() => loaded == Constants.limitQuery;

  bool get sortAscending => _sortAscending;

  int? get sortColumnIndex => _sortColumnIndex;

  changeLoading() {
    isLoading = !isLoading;
    if (!isDisposed) notifyListeners();
  }

  Future<void> getCurrenciesList() async {
    if (isLoading) return;

    _sortColumnIndex = null;
    error = null;
    _currenciesList.clear();
    loaded = Constants.loadingLimit;

    changeLoading();
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final newCurrencies = await coinCapService.getCurrencies();
      _currenciesList.addAll(newCurrencies);
    } on AppError catch (e) {
      error = e.message;
    } finally {
      changeLoading();
    }
  }

  int _compareString(String value1, String value2) =>
      _sortAscending ? value1.compareTo(value2) : value2.compareTo(value1);

  int _compareNum(num value1, num value2) =>
      _sortAscending ? value1.compareTo(value2) : value2.compareTo(value1);

  void changeSort({int? columnIndex = 0, bool ascending = true}) {
    _sortColumnIndex = columnIndex;
    _sortAscending = ascending;

    switch (_sortColumnIndex) {
      case 1:
        _currenciesList.sort((c1, c2) => _compareString(c1.name!, c2.name!));
        break;
      case 2:
        _currenciesList.sort((c1, c2) => _compareNum(c1.priceUsd, c2.priceUsd));
        break;
      default:
        _currenciesList.sort((c1, c2) => _compareNum(c1.rank, c2.rank));
    }

    if (!isDisposed) notifyListeners();
  }

  changeLoadingMore() {
    isLoadingMore = !isLoadingMore;
    if (!isDisposed) notifyListeners();
  }

  Future<void> loadMore() async {
    if (isLoadingMore) return;

    changeLoadingMore();
    await Future.delayed(const Duration(milliseconds: 1000));
    loaded += Constants.loadingLimit;
    changeLoadingMore();
  }

  @override
  void dispose() {
    isDisposed = true;
    super.dispose();
  }
}
