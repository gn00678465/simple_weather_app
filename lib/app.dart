import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator_platform_interface/src/models/position.dart';
import 'package:simple_weather_app/providers/env_provider.dart';
import 'package:simple_weather_app/providers/location_provider.dart';
import 'package:simple_weather_app/providers/weather_provider.dart';

void runWithAppConfig() async {
  const String openWeatherApi = String.fromEnvironment('OPEN_WEATHER_API');

  if (openWeatherApi.isEmpty) {
    throw 'OpenWeatherAPI not set!';
  }

  WidgetsFlutterBinding.ensureInitialized();

  runApp(ProviderScope(
    overrides: [
      envProvider.overrideWithValue({
        'OPEN_WEATHER_API': openWeatherApi,
      }),
    ],
    child: const App(),
  ));
}

class App extends ConsumerWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(context, ref) {
    // final weather = ref.watch(weatherProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Demo'),
      ),
      body: Center(
        child: Column(
          children: [
            // weather.when(
            //   data: (data) {
            //     return Column(
            //       children: [
            //         Text(
            //           'Your current city is: ${data?.city}',
            //         ),
            //         Text(
            //           'Your current temp is: ${data?.temp}',
            //         )
            //       ],
            //     );
            //   },
            //   error: (error, stackTrace) {
            //     debugPrint("$error");
            //     return Container();
            //   },
            //   loading: () => Container(),
            // )
          ],
        ),
      ),
    );
  }
}
