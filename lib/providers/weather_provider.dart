import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import 'package:simple_weather_app/model/weather_model.dart';
import './location_provider.dart';
import './providers.dart';

final currentWeatherProvider = FutureProvider.autoDispose((ref) async {
  Position? position;

  final apiKey =
      ref.watch(envProvider.select((value) => value['OPEN_WEATHER_API']));

  try {
    position = await ref.watch(positionProvider.future);
  } catch (e) {
    position = null;
  }

  if (position != null && apiKey != null) {
    return await WeatherModel.fetchWeather(apiKey: apiKey, position: position);
  }
  return null;
});

class WeathersNotifier extends StateNotifier<List<WeatherModel>> {
  WeathersNotifier() : super([]);

  void readPositions() {}

  void setPosition() {}

  void removePosition() {}
}

final weathersProvider =
    StateNotifierProvider<WeathersNotifier, List<WeatherModel>>((ref) {
  final weatherNotifier = WeathersNotifier();

  return weatherNotifier;
});
