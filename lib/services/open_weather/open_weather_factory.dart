part of open_weather_library;

/// https://github.com/cph-cachet/flutter-plugins/blob/master/packages/weather/lib/src/weather_domain.dart

class OpenWeather {
  final String _apiKey;
  late Language language;
  late Dio _dio;

  static const String fiveDayForecast = 'forecast';
  static const String currentWeather = 'weather';
  static const int statusOk = 200;

  OpenWeather(this._apiKey, {this.language = Language.CHINESE_TRADITIONAL}) {
    _dio = Dio();
  }

  Future<WeatherModel?> currentWeatherByLocation(
      double latitude, double longitude) async {
    Map<String, dynamic>? result =
        await _sendRequest(currentWeather, lat: latitude, lon: longitude);
    return result != null ? WeatherModel.fromJson(result) : null;
  }

  Future<Map<String, dynamic>?> _sendRequest(String tag,
      {double? lat, double? lon, String? cityName}) async {
    String url = _buildUrl(tag, cityName, lat, lon);

    Response<Map<String, dynamic>> response = await _dio.get(
      url,
      options: Options(
        method: 'GET',
        contentType: 'json',
        responseType: ResponseType.json,
      ),
    );

    if (response.statusCode == statusOk) {
      return response.data;
    } else {
      throw OpenWeatherAPIException(
          "The API threw an exception: ${response.data.toString()}");
    }
  }

  String _buildUrl(String tag, String? cityName, double? lat, double? lon) {
    final Map<String, dynamic> queryParameters = {
      'appid': _apiKey,
      'lang': _languageCode[language],
    };

    if (cityName != null) {
      queryParameters['cityName'] = cityName;
    } else {
      queryParameters['lat'] = lat;
      queryParameters['lon'] = lon;
    }

    return Uri(
      scheme: 'https',
      host: 'api.openweathermap.org',
      path: '/data/2.5/$tag',
      queryParameters: queryParameters,
    ).toString();
  }
}
