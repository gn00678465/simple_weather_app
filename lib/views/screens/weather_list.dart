import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:simple_weather_app/providers/weather_provider.dart';
import 'package:simple_weather_app/views/widgets/pull_down_actions.dart';
import 'package:simple_weather_app/views/widgets/search_city_field.dart';
import 'package:simple_weather_app/views/widgets/weather_card.dart';
import 'package:simple_weather_app/views/screens/weather_detail.dart';

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
    final weathers = ref.watch(weatherProvider);

    return CupertinoPageScaffold(
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
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
          ];
        },
        body: NotificationListener<ScrollNotification>(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 28),
                child: SearchCityField(),
              ),
              Expanded(
                child: ListView.separated(
                  padding:
                      const EdgeInsets.only(bottom: 16, left: 28, right: 28),
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 8,
                  ),
                  itemCount: weathers.length,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Hero(
                        tag: 'weather-cart-$index',
                        child: GestureDetector(
                          child: WeatherCard(
                            index: index,
                            isCurrent: true,
                            isMinimized: isEditable,
                            weatherInfo: weathers[index],
                          ),
                          onTap: () {
                            if (isEditable) return;
                            _gotoDetailsPage(
                              context: context,
                              index: index,
                              count: weathers.length,
                              isCurrent: true,
                            );
                          },
                        ),
                      );
                    }
                    return Row(
                      children: [
                        _animatedAction(
                          const Icon(
                            CupertinoIcons.minus_circle,
                            color: CupertinoColors.systemRed,
                          ),
                          isEditable,
                          width: 40,
                          duration: const Duration(milliseconds: 300),
                        ),
                        Flexible(
                          child: Hero(
                            tag: 'weather-cart-$index',
                            child: GestureDetector(
                              child: WeatherCard(
                                index: index,
                                isMinimized: isEditable,
                                weatherInfo: weathers[index],
                              ),
                              onTap: () {
                                if (isEditable) return;
                                _gotoDetailsPage(
                                  context: context,
                                  index: index,
                                  count: weathers.length,
                                );
                              },
                            ),
                          ),
                        ),
                        _animatedAction(
                          const Icon(
                            CupertinoIcons.line_horizontal_3,
                            color: CupertinoColors.inactiveGray,
                          ),
                          isEditable,
                          width: 40,
                          duration: const Duration(milliseconds: 300),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _gotoDetailsPage({
    required BuildContext context,
    required int index,
    required int count,
    bool isCurrent = false,
  }) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        fullscreenDialog: true,
        allowSnapshotting: false,
        builder: (BuildContext context) {
          return WeatherDetail(
            index: index,
            itemCount: count,
            isCurrent: isCurrent,
          );
        },
        settings: RouteSettings(name: 'weather-card', arguments: index),
      ),
    );
  }
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
      ));
}
