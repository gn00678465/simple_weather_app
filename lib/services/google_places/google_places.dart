import 'dart:async';
import 'package:dio/dio.dart';

import './exceptions.dart';
import './region.dart';
import 'package:simple_weather_app/providers/weather_provider.dart';

enum GooglePlacesOutput { json, xml }

class GooglePlaces {
  GooglePlaces(
    this._apiKey, {
    this.output = GooglePlacesOutput.json,
    this.language = PlacesLanguage.chineseTraditional,
  }) {
    final options = BaseOptions(
      baseUrl: 'https://maps.googleapis.com',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
    );

    _dio = Dio(options);
  }

  static const int statusOk = 200;

  final String _apiKey;
  late PlacesLanguage language;
  late Dio _dio;
  final GooglePlacesOutput output;

  Future<List<dynamic>?> autocomplete(
    String input, {
    String? types,
    double? latitude,
    double? longitude,
    int? radius,
  }) async {
    Map<String, dynamic>? result = await _sendRequest(
      'autocomplete',
      input: input,
      types: types,
      latitude: latitude,
      longitude: longitude,
      radius: radius,
    );

    if (result != null && result['status'] == 'OK') {
      return result['predictions'];
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>?> placeDetail(String place_id) async {
    Map<String, dynamic>? result = await _sendRequest<Map<String, dynamic>?>(
      'details',
      place_id: place_id,
      fields: 'formatted_address,name,geometry',
    );

    if (result != null && result['status'] == 'OK') {
      return result['result'] as Map<String, dynamic>;
    } else {
      return null;
    }
  }

  Future<T?> _sendRequest<T>(
    String methods, {
    String? input,
    String? place_id,
    String? fields,
    String? types,
    double? latitude,
    double? longitude,
    int? radius = 500,
  }) async {
    final Map<String, dynamic> queryParameters = {
      'key': _apiKey,
      'region': regionCode[language],
      'language': languageCode[language],
    };

    if (input != null) {
      queryParameters['input'] = input;
    }

    if (place_id != null) {
      queryParameters['place_id'] = place_id;
    }

    if (fields != null) {
      queryParameters['fields'] = fields;
    }

    if (latitude != null && longitude != null) {
      queryParameters['location'] = '$latitude,$longitude';
      queryParameters['radius'] = radius.toString();
    }

    if (types != null) {
      queryParameters['types'] = types;
    }

    Response<T> response = await _dio.get(
      '/maps/api/place/$methods/${output.name}',
      queryParameters: queryParameters,
      options: Options(
        method: 'GET',
        contentType: 'json',
        responseType: ResponseType.json,
      ),
    );

    if (response.statusCode == statusOk) {
      return response.data;
    } else {
      throw GooglePlacesAPIException(
          "The API threw an exception: ${response.data.toString()}");
    }
  }
}
