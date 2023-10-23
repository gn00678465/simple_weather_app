import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import 'package:simple_weather_app/model/weather_model.dart';
import './location_provider.dart';
import './env_provider.dart';

class WeatherNotifier extends StateNotifier<List<WeatherModel>> {
  WeatherNotifier() : super([]);

  void updateCurrentWeather({
    required Future<Position?> position,
    required String? apiKey,
  }) async {
    final p = await position;

    final info = await WeatherModel.fetchWeather(apiKey: apiKey!, position: p!);
    if (info != null) {
      if (state.isEmpty) {
        state = [info, ...state];
      } else {
        state = List.from(state)..[0] = info;
      }
    }
  }
}

final weatherProvider =
    StateNotifierProvider.autoDispose<WeatherNotifier, List<WeatherModel>>(
        (ref) {
  final weatherNotifier = WeatherNotifier();

  final apiKey =
      ref.watch(envProvider.select((value) => value['OPEN_WEATHER_API']));

  ref.listen(positionProvider.future, (prev, next) {
    weatherNotifier.updateCurrentWeather(position: next, apiKey: apiKey);
  });

  return weatherNotifier;
});
