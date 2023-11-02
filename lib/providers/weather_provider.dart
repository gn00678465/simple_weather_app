import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:simple_weather_app/services/open_weather/open_weather.dart';
import 'package:simple_weather_app/model/location_model.dart';
import 'package:simple_weather_app/model/weather_model.dart';
import 'package:simple_weather_app/utils/list.dart';
import './providers.dart';

const String _openWeatherKey = String.fromEnvironment('OPEN_WEATHER_API');
final _openWeatherSDK = OpenWeather(_openWeatherKey);

const _positionKey = 'pos';

class WeathersNotifier extends StateNotifier<List<WeatherModel?>> {
  WeathersNotifier({required this.sharedPrefs}) : super([]);

  final SharedPreferences sharedPrefs;

  List<LocationModel> _getPositionList() {
    final List<String>? stringList = sharedPrefs.getStringList(_positionKey);

    if (stringList == null) return [];
    return fromStringList<LocationModel>(stringList,
        decode: LocationModel.fromJson);
  }

  Future<void> _setPositionList(List<LocationModel> list) async {
    final List<String> stringList = toStringList(list);
    await sharedPrefs.setStringList(_positionKey, stringList);
  }

  Future<void> setNewPosition(LocationModel position) async {
    final originList = _getPositionList();
    await _setPositionList([...originList, position]);
  }

  void setNewWeather(WeatherModel? weather) {
    state = [...state, weather];
  }

  Future<void> setNewPositionAndWeather(
      LocationModel position, WeatherModel weather) async {
    setNewWeather(weather.copyWith(city: position.name));
    await setNewPosition(position);
  }

  Future<void> removePosition(int index) async {
    if (index == 0) return;
    removeWeather(index);
    final originList = _getPositionList();
    final List<LocationModel> newList = List.from(originList)
      ..removeAt(index - 1);
    await _setPositionList(newList);
  }

  void updateWeather(WeatherModel? weather, int index) {
    if (index >= state.length) {
      setNewWeather(weather);
    } else {
      state = List.from(state)..[index] = weather;
    }
  }

  void removeWeather(int index) {
    state = List.from(state)..removeAt(index);
  }

  Future<void> initialState(Future<Position?> position) async {
    final List<WeatherModel?> weathers = [];
    final Position? current = await position;
    final WeatherModel? currentWeather = current != null
        ? await _openWeatherSDK.currentWeatherByLocation(
            current.latitude, current.longitude)
        : null;
    if (currentWeather != null) {
      currentWeather.currentPosition = true;
      weathers.add(currentWeather);
    }

    final list = _getPositionList();
    for (final position in list) {
      final weather = await _openWeatherSDK.currentWeatherByLocation(
          position.lat, position.lng);
      weathers.add(weather!.copyWith(city: position.name));
    }

    if (weathers.isNotEmpty) {
      state = weathers;
    }
  }
}

final weathersProvider =
    StateNotifierProvider.autoDispose<WeathersNotifier, List<WeatherModel?>>(
        (ref) {
  final sharedPrefs = ref.watch(sharedPreferencesProvider);

  final weatherNotifier = WeathersNotifier(sharedPrefs: sharedPrefs);

  return weatherNotifier;
});

final weatherCounts = Provider.autoDispose<int>((ref) {
  final weathers = ref.watch(weathersProvider);

  return weathers.length;
});
