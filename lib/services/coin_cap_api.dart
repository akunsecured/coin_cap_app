import 'package:coin_cap_app/utils/constants.dart';
import 'package:dio/dio.dart';

class CoinCapApi {
  late final Dio dio;

  CoinCapApi() {
    var options = BaseOptions(
      baseUrl: Constants.apiBaseUrl,
    );
    dio = Dio(options);
  }

  Future<Response?> getCoins() async {
    final response = await dio
        .get('/assets', queryParameters: {'limit': Constants.maxLimit});
    if (response.statusCode == 200) {
      return response;
    }
    return null;
  }
}
