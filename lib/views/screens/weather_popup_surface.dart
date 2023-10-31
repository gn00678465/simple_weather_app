import 'package:flutter/cupertino.dart';

import 'package:simple_weather_app/model/weather_model.dart';
import 'package:simple_weather_app/services/open_weather/open_weather.dart';
import './weather_detail.dart';

const String _openWeatherKey = String.fromEnvironment('OPEN_WEATHER_API');
final _openWeatherSDK = OpenWeather(_openWeatherKey);

Future<WeatherModel?> _fetchWeather(double lat, double lng) async {
  final weather = await _openWeatherSDK.currentWeatherByLocation(lat, lng);
  return weather;
}

void showWeatherModalPopup(
    BuildContext context, Map<String, dynamic> location) {
  void pop(BuildContext context, {WeatherModel? weather}) {
    Navigator.of(context).pop(weather);
  }

  DecorationImage? image;

  showCupertinoModalPopup<void>(
    context: context,
    builder: (_) => CupertinoPopupSurface(
      isSurfacePainted: false,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(
              top: Radius.circular(8), bottom: Radius.zero),
          color: CupertinoColors.systemCyan,
          image: image,
        ),
        height: MediaQuery.of(_).size.height * 0.90,
        child: FutureBuilder(
          future: _fetchWeather(location['lat'], location['lng']),
          builder: (context, snapshot) {
            return Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  child: CupertinoButton(
                    color: CupertinoColors.systemFill,
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 24),
                    onPressed: () {
                      pop(context);
                    },
                    child: const Text(
                      '取消',
                      style: TextStyle(
                        color: CupertinoColors.white,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: CupertinoButton(
                    color: CupertinoColors.systemFill,
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 24),
                    onPressed: () {
                      pop(context, weather: snapshot.data);
                    },
                    child: const Text(
                      '加入',
                      style: TextStyle(
                        color: CupertinoColors.white,
                      ),
                    ),
                  ),
                ),
                switch (snapshot.connectionState) {
                  ConnectionState.none => const SizedBox.shrink(),
                  ConnectionState.waiting => const Center(
                      child: CupertinoActivityIndicator(
                        radius: 20.0,
                      ),
                    ),
                  ConnectionState.done => PageViewContent(
                      weatherInfo: snapshot.data!,
                      isCurrent: false,
                    ),
                  _ => const SizedBox.shrink(),
                }
              ],
            );
          },
        ),
      ),
    ),
  );
}
