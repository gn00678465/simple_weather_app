import 'dart:async';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';

import './exceptions.dart';

enum GooglePlacesOutput { json, xml }

class GooglePlaces {
  GooglePlaces(
    this._apiKey, {
    Locale? locale,
    this.output = GooglePlacesOutput.json,
  }) {
    _locale = locale;
    _dio = Dio();
  }

  static const int statusOk = 200;

  final String _apiKey;
  late Locale? _locale;
  late Dio _dio;
  final GooglePlacesOutput output;

  Future<Map<String, dynamic>?> autocomplete(
    String input, {
    double? latitude,
    double? longitude,
    int? radius,
  }) async {
    Map<String, dynamic>? retult = await _request(
      'autocomplete',
      input,
      latitude: latitude,
      longitude: longitude,
      radius: radius,
    );
  }

  Future<Map<String, dynamic>?> _request(
    String methods,
    String input, {
    double? latitude,
    double? longitude,
    int? radius,
  }) async {
    final String url = _buildUrl(
      methods,
      input,
      latitude: latitude,
      longitude: longitude,
      radius: radius,
    );

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
      throw GooglePlacesAPIException(
          "The API threw an exception: ${response.data.toString()}");
    }
  }

  String _buildUrl(
    String methods,
    String input, {
    double? latitude,
    double? longitude,
    int? radius = 500,
  }) {
    final Map<String, dynamic> queryParameters = {
      'key': _apiKey,
      'region': _locale,
    };

    if (latitude != null && longitude != null) {
      queryParameters['location'] = '$latitude,$longitude';
      queryParameters['radius'] = radius.toString();
    }

    return Uri(
      scheme: 'https',
      host: 'maps.googleapis.com',
      path: '/maps/api/place/$methods/${output.name}',
      queryParameters: queryParameters,
    ).toString();
  }
}
