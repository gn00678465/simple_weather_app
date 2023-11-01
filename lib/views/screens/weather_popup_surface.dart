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

Widget _content(
  BuildContext context, {
  required Widget child,
  BoxDecoration? decoration,
  WeatherModel? weather,
}) {
  return Container(
    decoration: decoration,
    height: MediaQuery.of(context).size.height - 60,
    child: Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          child: CupertinoButton(
            color: CupertinoColors.systemFill,
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 24),
            onPressed: () {
              Navigator.of(context).pop();
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
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 24),
            onPressed: () {
              Navigator.of(context).pop(weather);
            },
            child: const Text(
              '加入',
              style: TextStyle(
                color: CupertinoColors.white,
              ),
            ),
          ),
        ),
        child,
      ],
    ),
  );
}

class WeatherPopupSurface extends StatelessWidget {
  const WeatherPopupSurface({super.key, required this.lat, required this.lng});

  final double lat;
  final double lng;

  @override
  Widget build(BuildContext context) {
    return CupertinoPopupSurface(
      isSurfacePainted: false,
      child: FutureBuilder(
        future: _fetchWeather(lat, lng),
        builder: (context, snapshot) {
          return switch (snapshot.connectionState) {
            ConnectionState.none => const SizedBox.shrink(),
            ConnectionState.waiting => _content(
                context,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(8), bottom: Radius.zero),
                  color: CupertinoColors.systemCyan,
                ),
                child: const Center(
                  child: CupertinoActivityIndicator(
                    radius: 20.0,
                  ),
                ),
              ),
            ConnectionState.done => _content(
                context,
                child: PageViewContent(
                  weatherInfo: snapshot.data!,
                ),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(8), bottom: Radius.zero),
                  color: CupertinoColors.systemCyan,
                  image: DecorationImage(
                    image: WeatherModel.weatherImage(snapshot.data!),
                    fit: BoxFit.cover,
                  ),
                ),
                weather: snapshot.data!,
              ),
            _ => const SizedBox.shrink(),
          };
        },
      ),
    );
  }
}
