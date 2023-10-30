import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import './exceptions.dart';
import './region.dart';

enum GooglePlacesOutput { json, xml }

class GooglePlaces {
  GooglePlaces(
    this._apiKey, {
    Region? region,
    this.output = GooglePlacesOutput.json,
  }) {
    final options = BaseOptions(
      baseUrl: 'https://maps.googleapis.com',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
    );

    _region = Region.tw;
    _dio = Dio(options);
  }

  static const int statusOk = 200;

  final String _apiKey;
  late Region? _region;
  late Dio _dio;
  final GooglePlacesOutput output;

  Future<List<Map<String, dynamic>>?> autocomplete(
    String input, {
    String? types,
    double? latitude,
    double? longitude,
    int? radius,
  }) async {
    Map<String, dynamic>? result = await _sendRequest(
      'autocomplete',
      input,
      types: types,
      latitude: latitude,
      longitude: longitude,
      radius: radius,
    );

    if (result != null && result['status'] == 'OK') {
      return result['predictions'];
    }
    return null;
  }

  Future<Map<String, dynamic>?> _sendRequest(
    String methods,
    String input, {
    String? types,
    double? latitude,
    double? longitude,
    int? radius = 500,
  }) async {
    final Map<String, dynamic> queryParameters = {
      'key': _apiKey,
      'region': _region?.name,
      'input': input,
    };

    if (latitude != null && longitude != null) {
      queryParameters['location'] = '$latitude,$longitude';
      queryParameters['radius'] = radius.toString();
    }

    if (types != null) {
      queryParameters['types'] = types;
    }

    Response<Map<String, dynamic>> response = await _dio.get(
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
