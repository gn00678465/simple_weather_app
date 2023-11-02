import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:simple_weather_app/model/weather_model.dart';
import 'package:simple_weather_app/providers/weather_provider.dart';
import 'package:simple_weather_app/views/screens/weather_detail.dart';
import 'package:simple_weather_app/views/widgets/pull_down_actions.dart';
import 'package:simple_weather_app/views/widgets/search_city_field.dart';
import 'package:simple_weather_app/views/widgets/weather_card.dart';
import 'package:simple_weather_app/views/widgets/sliver_header_delegate.dart';
import 'package:simple_weather_app/views/widgets/editable_item.dart';

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

  void _deleteWeather(int index) {
    ref.read(weathersProvider.notifier).removePosition(index);
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
                                key: ValueKey(weather),
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
                            : DismissibleWidget(
                                key: ValueKey(weather),
                                onDismissed: (DismissDirection direction) {
                                  _deleteWeather(idx);
                                },
                                child: EditableItem(
                                  onLeftTap: () {
                                    _deleteWeather(idx);
                                  },
                                  isExpanded: isEditable,
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
                                ));
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

class DismissibleWidget extends StatefulWidget {
  const DismissibleWidget({
    required Key key,
    required this.child,
    this.onDismissed,
  }) : super(key: key);

  final Widget child;
  final void Function(DismissDirection)? onDismissed;

  @override
  State<DismissibleWidget> createState() => _DismissibleWidget();
}

class _DismissibleWidget extends State<DismissibleWidget> {
  double progress = 0.0;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: widget.key!,
      background: const ColoredBox(
        color: CupertinoColors.systemRed,
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Icon(Icons.delete, color: CupertinoColors.white),
          ),
        ),
      ),
      direction: DismissDirection.endToStart,
      dismissThresholds: const {
        DismissDirection.endToStart: 0.5,
      },
      onResize: () {
        debugPrint('onResize');
      },
      onUpdate: (DismissUpdateDetails details) {
        // setState(() {
        //   progress = details.progress;
        // });
      },
      onDismissed: widget.onDismissed,
      child: widget.child,
    );
  }
}
