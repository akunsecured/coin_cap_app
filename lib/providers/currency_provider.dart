import 'package:coin_cap_app/models/currency.dart';
import 'package:coin_cap_app/models/currency_history.dart';
import 'package:coin_cap_app/models/date_interval.dart';
import 'package:coin_cap_app/services/coin_cap_service.dart';
import 'package:coin_cap_app/utils/errors.dart';
import 'package:flutter/foundation.dart';

class CurrencyProvider extends ChangeNotifier {
  CoinCapService coinCapService = CoinCapService();
  final String? id;
  late DateInterval selectedInterval;
  late List<bool> isSelected;
  Currency? currency;
  final List<CurrencyHistory> currencyHistories = [];
  bool isLoading = false, isLoadingHistory = false, isDisposed = false;
  String? error;

  CurrencyProvider(this.id) {
    if (id == null || id!.isEmpty) {
      error = "Error: currency not found";
    } else {
      selectedInterval = DateInterval.fromIntervalEnum(IntervalEnum.oneDay);
      isSelected = [
        true,
        ...List.filled(IntervalEnum.values.length - 1, false)
      ];
      getCurrencyWithHistory();
    }
  }

  void changeSelected(int newIndex) {
    if (isLoadingHistory) return;

    isSelected = List.filled(isSelected.length, false);
    isSelected[newIndex] = true;
    if (!isDisposed) notifyListeners();

    selectedInterval =
        DateInterval.fromIntervalEnum(IntervalEnum.values[newIndex]);
    getHistory();
  }

  changeLoading() {
    isLoading = !isLoading;
    if (!isDisposed) notifyListeners();
  }

  void getCurrencyWithHistory() async {
    if (isLoading) return;

    currencyHistories.clear();
    error = null;

    changeLoading();
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final result =
          await coinCapService.getCurrencyWithHistory(id!, selectedInterval);
      currency = result['currency'];
      currencyHistories.addAll(result['currencyHistories']);
    } on AppError catch (e) {
      error = e.message;
    } finally {
      changeLoading();
    }
  }

  changeLoadingHistory() {
    isLoadingHistory = !isLoadingHistory;
    if (!isDisposed) notifyListeners();
  }

  void getHistory() async {
    currencyHistories.clear();
    error = null;

    changeLoadingHistory();
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final result =
          await coinCapService.getCurrencyHistory(id!, selectedInterval);
      currencyHistories.addAll(result);
    } on AppError catch (e) {
      error = e.message;
    } finally {
      changeLoadingHistory();
    }
  }

  @override
  void dispose() {
    isDisposed = true;
    super.dispose();
  }
}
