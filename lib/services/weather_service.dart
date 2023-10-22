import 'dart:core';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import '../model/weather_model.dart';

enum EnumWeatherUnits { metric, imperial }

enum EnumWeatherLang {
  zh_tw,
  en,
  ja,
}

final dio = Dio();

Future<WeatherModel?> fetchWeatherByPosition({
  required Position position,
  required String apiKey,
  EnumWeatherUnits? units,
  EnumWeatherLang? lang,
}) async {
  final String weatherUri = Uri(
    scheme: 'https',
    host: 'api.openweathermap.org',
    path: '/data/2.5/weather',
    queryParameters: {
      'lat': position.latitude.toString(),
      'lon': position.longitude.toString(),
      'appid': apiKey,
      'units': units?.name ?? EnumWeatherUnits.metric.name,
      'lang': lang?.name ?? EnumWeatherLang.zh_tw.name,
    },
  ).toString();

  try {
    Response<Map<String, dynamic>> response = await dio.get(
      weatherUri,
      options: Options(
        method: 'GET',
        contentType: 'json',
        responseType: ResponseType.json,
      ),
    );
    if (response.statusCode == 200) {
      return WeatherModel.fromJson(response.data!);
    }
  } on DioException catch (e) {
    if (e.response != null) {
      print(e.response?.data);
      print(e.response?.headers);
      print(e.response?.requestOptions);
    } else {
      // Something happened in setting up or sending the request that triggered an Error
      print(e.requestOptions);
      print(e.message);
    }
  }
  return null;
}
