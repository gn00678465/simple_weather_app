import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_weather_app/model/weather_model.dart';

import 'package:simple_weather_app/providers/weather_provider.dart';
import 'package:simple_weather_app/views/widgets/pull_down_actions.dart';
import 'package:simple_weather_app/views/widgets/search_city_field.dart';
import 'package:simple_weather_app/views/widgets/weather_card.dart';
import 'package:simple_weather_app/views/screens/weather_detail.dart';
import 'package:simple_weather_app/views/widgets/sliver_header_delegate.dart';

class WeatherList extends ConsumerStatefulWidget {
  const WeatherList({super.key});

  @override
  ConsumerState<WeatherList> createState() => _WeatherList();
}

class _WeatherList extends ConsumerState<WeatherList> {
  bool isEditable = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentWeather = ref.watch(currentWeatherProvider);

    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 28),
            largeTitle: const Padding(
              padding: EdgeInsets.only(left: 12),
              child: Text(
                '天氣',
                style: TextStyle(color: CupertinoColors.white),
              ),
            ),
            trailing: isEditable
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        isEditable = false;
                      });
                    },
                    child: const Text(
                      '完成',
                      style: TextStyle(
                        color: CupertinoColors.white,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  )
                : PullDownActions(
                    onPressEdit: () {
                      setState(() {
                        isEditable = true;
                      });
                    },
                    onPressUnit: () {},
                  ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 28),
            sliver: SliverPersistentHeader(
              pinned: true,
              delegate: SliverHeaderDelegate.fixedHeight(
                height: 40,
                child: const SearchCityField(),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 28),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  Wrap(
                    runSpacing: 8.0,
                    children: [
                      currentWeather.when(
                        skipLoadingOnReload: true,
                        data: (data) {
                          if (data != null) {
                            const heroTag = 'weather-cart-0';
                            return WeatherCard(
                              heroTag: heroTag,
                              index: 0,
                              isCurrent: true,
                              isMinimized: isEditable,
                              weatherInfo: data,
                              onTap: () {
                                if (isEditable) return;
                                _gotoDetailsPage(
                                  heroTag: heroTag,
                                  context: context,
                                  index: 0,
                                  count: 2,
                                  weatherInfo: data,
                                  isCurrent: true,
                                );
                              },
                            );
                          }
                          return const SizedBox.shrink();
                        },
                        error: (err, stack) => Text('Error: $err'),
                        loading: () => const SizedBox.shrink(),
                      ),
                      // currentWeather.when(
                      //   skipLoadingOnReload: true,
                      //   data: (data) {
                      //     if (data != null) {
                      //       const heroTag = 'weather-cart-1';
                      //       return _editableWeatherCard(
                      //         child: WeatherCard(
                      //           heroTag: heroTag,
                      //           index: 1,
                      //           isMinimized: isEditable,
                      //           weatherInfo: data,
                      //           onTap: () {
                      //             if (isEditable) return;
                      //             _gotoDetailsPage(
                      //               heroTag: heroTag,
                      //               context: context,
                      //               index: 1,
                      //               count: 2,
                      //               weatherInfo: data,
                      //             );
                      //           },
                      //         ),
                      //         isExpanded: isEditable,
                      //       );
                      //     }
                      //     return const SizedBox.shrink();
                      //   },
                      //   error: (err, stack) => Text('Error: $err'),
                      //   loading: () => const SizedBox.shrink(),
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _gotoDetailsPage({
    required BuildContext context,
    required int index,
    required int count,
    required WeatherModel weatherInfo,
    required String heroTag,
    bool isCurrent = false,
  }) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        fullscreenDialog: true,
        allowSnapshotting: false,
        builder: (BuildContext context) {
          return WeatherDetail(
            heroTag: heroTag,
            index: index,
            itemCount: count,
            isCurrent: isCurrent,
          );
        },
        settings: RouteSettings(name: 'weather-card', arguments: weatherInfo),
      ),
    );
  }
}

Widget _editableWeatherCard({
  required Widget child,
  required bool isExpanded,
}) {
  const Duration duration = Duration(milliseconds: 300);
  const double width = 40;

  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      _animatedAction(
        const Icon(
          CupertinoIcons.minus_circle,
          color: CupertinoColors.systemRed,
        ),
        isExpanded,
        width: width,
        duration: duration,
      ),
      Flexible(
        child: child,
      ),
      _animatedAction(
        const Icon(
          CupertinoIcons.line_horizontal_3,
          color: CupertinoColors.inactiveGray,
        ),
        isExpanded,
        width: width,
        duration: duration,
      ),
    ],
  );
}

Widget _animatedAction(
  Widget child,
  bool isExpanded, {
  required double width,
  required Duration duration,
}) {
  return AnimatedContainer(
    duration: duration,
    width: isExpanded ? width : 0,
    child: AnimatedOpacity(
      duration: duration,
      opacity: isExpanded ? 1 : 0,
      child: Align(
        alignment: Alignment.center,
        child: SizedBox(
          width: width,
          child: child,
        ),
      ),
    ),
  );
}
