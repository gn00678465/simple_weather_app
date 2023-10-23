import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:simple_weather_app/providers/env_provider.dart';
import 'package:simple_weather_app/views/screens/weather_list.dart';
// import 'package:geolocator_platform_interface/src/models/position.dart';
// import 'package:simple_weather_app/providers/location_provider.dart';
// import 'package:simple_weather_app/providers/weather_provider.dart';

void runWithAppConfig() async {
  const String openWeatherApi = String.fromEnvironment('OPEN_WEATHER_API');

  if (openWeatherApi.isEmpty) {
    throw 'OpenWeatherAPI not set!';
  }

  WidgetsFlutterBinding.ensureInitialized();

  runApp(ProviderScope(
    overrides: [
      envProvider.overrideWithValue({'OPEN_WEATHER_API': openWeatherApi}),
    ],
    child: const App(),
  ));
}

class App extends ConsumerWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CupertinoApp(
      title: 'Simple Weather App',
      theme: const CupertinoThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: CupertinoColors.black,
        barBackgroundColor: CupertinoColors.black,
      ),
      routes: Router.routes,
      initialRoute: Router.home,
      onGenerateRoute: Router.generateRoute,
    );
  }
}

class Router {
  static String home = '/';
  static String current = '/current';

  static Map<String, WidgetBuilder> routes = {
    home: (context) => const WeatherList(),
    current: (context) => const WeatherList(),
  };

  static Route? generateRoute(context) {
    return CupertinoPageRoute(
      builder: (context) => const WeatherList(),
    );
  }
}
