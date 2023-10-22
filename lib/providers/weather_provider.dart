import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_weather_app/model/weather_model.dart';
import './location_provider.dart';
import './env_provider.dart';

final weatherProvider = StreamProvider.autoDispose<WeatherModel?>((ref) {
  final streamController = StreamController<WeatherModel?>();

  final currentPosition = ref.watch(positionProvider);
  final String apiKey =
      ref.watch(envProvider.select((value) => value['OPEN_WEATHER_API']!));

  currentPosition.when(
    data: (data) async {
      if (data != null) {
        final info =
            await WeatherModel.fetchWeather(position: data, apiKey: apiKey);
        streamController.add(info);
      }
    },
    error: (error, stackTrace) {
      streamController.addError(error);
    },
    loading: () {},
  );

  return streamController.stream;
});
