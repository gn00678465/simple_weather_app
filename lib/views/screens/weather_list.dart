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
    final weathers = ref.watch(weathersProvider);
    final count = ref.watch(weatherCounts);

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
                    children: weathers.asMap().entries.map((entry) {
                      int idx = entry.key;
                      WeatherModel? weather = entry.value;
                      String heroTag = 'weather-cart-$idx';
                      if (weather != null) {
                        return weather.currentPosition
                            ? WeatherCard(
                                heroTag: heroTag,
                                index: idx,
                                isMinimized: isEditable,
                                weatherInfo: weather,
                                onTap: () {
                                  if (isEditable) return;
                                  _gotoDetailsPage(
                                    heroTag: heroTag,
                                    context: context,
                                    index: idx,
                                    count: count,
                                    weatherInfo: weather,
                                  );
                                },
                              )
                            : _editableWeatherCard(
                                child: WeatherCard(
                                  heroTag: heroTag,
                                  index: idx,
                                  isMinimized: isEditable,
                                  weatherInfo: weather,
                                  onTap: () {
                                    if (isEditable) return;
                                    _gotoDetailsPage(
                                      heroTag: heroTag,
                                      context: context,
                                      index: idx,
                                      count: count,
                                      weatherInfo: weather,
                                    );
                                  },
                                ),
                                isExpanded: isEditable,
                                onDelete: () {
                                  ref
                                      .read(weathersProvider.notifier)
                                      .removePosition(idx);
                                },
                              );
                      }
                      return const SizedBox.shrink();
                    }).toList(),
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
          );
        },
      ),
    );
  }
}

Widget _editableWeatherCard({
  required Widget child,
  required bool isExpanded,
  void Function()? onDelete,
}) {
  const Duration duration = Duration(milliseconds: 300);
  const double width = 40;

  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      GestureDetector(
        onTap: onDelete,
        child: _animatedAction(
          const Icon(
            CupertinoIcons.minus_circle,
            color: CupertinoColors.systemRed,
          ),
          isExpanded,
          width: width,
          duration: duration,
        ),
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
