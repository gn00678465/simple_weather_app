import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:simple_weather_app/services/open_weather/open_weather.dart';
import 'package:simple_weather_app/model/weather_model.dart';
import './location_provider.dart';
import './providers.dart';

const String _openWeatherKey = String.fromEnvironment('OPEN_WEATHER_API');
final _openWeatherSDK = OpenWeather(_openWeatherKey);

class WeathersNotifier extends StateNotifier<List<WeatherModel?>> {
  WeathersNotifier({required this.sharedPrefs}) : super([]);

  final SharedPreferences sharedPrefs;

  void readAllPositions() {}

  void setNewPosition(Map<String, dynamic> position) {
    final String pos = jsonEncode(position);
    debugPrint('sharedPrefs: $sharedPrefs');
  }

  void setNewWeather(WeatherModel? weather) {
    state = [...state, weather];
  }

  void setNewPositionAndWeather(
      Map<String, dynamic> position, WeatherModel weather) {
    setNewPosition(position);
    setNewWeather(weather);
  }

  void removePosition() {}

  void updateWeather(WeatherModel? weather, int index) {
    if (index >= state.length) {
      setNewWeather(weather);
    } else {
      state = List.from(state)..[index] = weather;
    }
  }

  void removeWeather() {}

  void initState() async {}
}

final weathersProvider =
    StateNotifierProvider.autoDispose<WeathersNotifier, List<WeatherModel?>>(
        (ref) {
  final _sharedPrefs = ref.watch(sharedPreferencesProvider);

  final weatherNotifier = WeathersNotifier(sharedPrefs: _sharedPrefs);

  ref.listen(
    positionProvider.future,
    (previous, next) async {
      final Position? position = await next;
      final WeatherModel? weather = position != null
          ? await _openWeatherSDK.currentWeatherByLocation(
              position.latitude, position.longitude)
          : null;

      if (weather != null) {
        weather.currentPosition = true;
      }

      weatherNotifier.updateWeather(weather, 0);
    },
  );

  return weatherNotifier;
});

final weatherCounts = Provider.autoDispose<int>((ref) {
  final weathers = ref.watch(weathersProvider);

  return weathers.length;
});
