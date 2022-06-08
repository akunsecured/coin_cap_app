import 'package:coin_cap_app/models/currency.dart';
import 'package:coin_cap_app/models/currency_history.dart';
import 'package:coin_cap_app/models/date_interval.dart';
import 'package:coin_cap_app/utils/constants.dart';
import 'package:coin_cap_app/utils/errors.dart';
import 'package:dio/dio.dart';

class CoinCapService {
  late final Dio _dio;

  CoinCapService() {
    var options = BaseOptions(
      baseUrl: Constants.apiBaseUrl,
    );
    _dio = Dio(options);
  }

  _checkStatusCode(Response response) {
    if (response.statusCode != 200) {
      throw AppError('Status code was ${response.statusCode}, not 200');
    }
  }

  Future<List<Currency>> getCurrencies() async {
    List<Currency> currencies = [];

    try {
      final response = await _dio
          .get('/assets', queryParameters: {'limit': Constants.limitQuery});
      _checkStatusCode(response);
      for (Map<String, dynamic> currency in response.data['data']) {
        currencies.add(Currency.fromJson(currency));
      }
    } on DioError catch (e) {
      throw AppError(e.error.message);
    } on Exception catch (e) {
      throw AppError(e.toString());
    }

    return currencies;
  }

  Future<List<CurrencyHistory>> getCurrencyHistory(
      String id, DateInterval dateInterval) async {
    List<CurrencyHistory> histories = [];

    try {
      final response = await _dio.get('/assets/$id/history', queryParameters: {
        'interval': dateInterval.interval,
        'start': dateInterval.start,
        'end': dateInterval.end
      });
      _checkStatusCode(response);

      for (Map<String, dynamic> currencyHistory in response.data['data']) {
        histories.add(CurrencyHistory.fromJson(currencyHistory));
      }
    } on DioError catch (e) {
      throw AppError(e.error.message);
    } on Exception catch (e) {
      throw AppError(e.toString());
    }

    return histories;
  }

  Future<Map<String, dynamic>> getCurrencyWithHistory(
      String id, DateInterval dateInterval) async {
    Map<String, dynamic> result = {};

    try {
      final currencyResponse = await _dio.get('/assets/$id');
      _checkStatusCode(currencyResponse);

      final currencyHistories = await getCurrencyHistory(id, dateInterval);
      var currency = Currency.fromJson(currencyResponse.data['data']);

      result['currency'] = currency;
      result['currencyHistories'] = currencyHistories;
    } on DioError catch (e) {
      throw AppError(e.error.toString());
    } on Exception catch (e) {
      throw AppError(e.toString());
    }

    return result;
  }
}
