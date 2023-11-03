import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:simple_weather_app/providers/providers.dart';
import 'package:simple_weather_app/views/screens/weather_list.dart';
import 'package:simple_weather_app/providers/location_provider.dart';
import 'package:simple_weather_app/providers/weather_provider.dart';

void runWithAppConfig() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (const String.fromEnvironment('OPEN_WEATHER_API').isEmpty) {
    throw 'OpenWeatherAPI not set!';
  }
  if (const String.fromEnvironment('GOOGLE_API').isEmpty) {
    throw 'Google API not set!';
  }

  final sharedPreferences = await SharedPreferences.getInstance();

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
        permissionsProvider.overrideWith((ref) => statuses),
      ],
      child: _EagerInitialization(
        statuses: statuses,
        child: const App(),
      ),
    ),
  );
}

class _EagerInitialization extends ConsumerWidget {
  const _EagerInitialization({
    required this.child,
    required this.statuses,
  });
  final Widget child;
  final Map<Permission, PermissionStatus> statuses;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final position = switch (statuses[Permission.location]) {
      PermissionStatus.granted => ref.watch(positionProvider.future),
      _ => Future.value(null),
    };

    ref.read(weathersProvider.notifier).initialState(position);

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
