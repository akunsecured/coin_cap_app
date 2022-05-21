import 'package:coin_cap_app/models/currency.dart';
import 'package:coin_cap_app/models/currency_history.dart';
import 'package:coin_cap_app/services/coin_cap_service.dart';
import 'package:coin_cap_app/utils/errors.dart';
import 'package:flutter/foundation.dart';

class CurrencyProvider extends ChangeNotifier {
  final String id;
  CoinCapService coinCapService = CoinCapService();
  Currency? currency;
  CurrencyHistory? currencyHistory;
  bool isLoading = false, isDisposed = false;
  String? error;

  CurrencyProvider(this.id) {
    getCurrencyWithHistory();
  }

  changeLoading() {
    isLoading = !isLoading;
    if (!isDisposed) notifyListeners();
  }

  void getCurrencyWithHistory() async {
    if (isLoading) return;

    error = null;

    changeLoading();
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final result = await coinCapService.getCurrencyWithHistory(id);
      currency = result['currency'];
      currencyHistory = result['currencyHistory'];
    } on AppError catch (e) {
      error = e.message;
    } finally {
      changeLoading();
    }
  }

  @override
  void dispose() {
    isDisposed = true;
    super.dispose();
  }
}