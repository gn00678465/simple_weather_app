import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:simple_weather_app/providers/providers.dart';
import 'package:simple_weather_app/views/screens/weather_list.dart';
// import 'package:geolocator_platform_interface/src/models/position.dart';
// import 'package:simple_weather_app/providers/location_provider.dart';
import 'package:simple_weather_app/providers/weather_provider.dart';

void runWithAppConfig() async {
  WidgetsFlutterBinding.ensureInitialized();

  const String openWeatherApi = String.fromEnvironment('OPEN_WEATHER_API');
  final sharedPreferences = await SharedPreferences.getInstance();

  if (openWeatherApi.isEmpty) {
    throw 'OpenWeatherAPI not set!';
  }

  if (await Permission.contacts.request().isGranted) {
    // Either the permission was already granted before or the user just granted it.
  }

// You can request multiple permissions at once.
  Map<Permission, PermissionStatus> statuses = await [
    Permission.location,
  ].request();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const _EagerInitialization(child: App()),
    ),
  );
}

class _EagerInitialization extends ConsumerWidget {
  const _EagerInitialization({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(weathersProvider);
    return child;
  }
}

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
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
