import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:simple_weather_app/model/weather_model.dart';
import 'package:simple_weather_app/providers/weather_provider.dart';

class WeatherDetail extends ConsumerStatefulWidget {
  final int index;
  final int itemCount;

  const WeatherDetail({
    super.key,
    required this.index,
    required this.itemCount,
  });

  @override
  ConsumerState<WeatherDetail> createState() => _WeatherDetail();
}

class _WeatherDetail extends ConsumerState<WeatherDetail> {
  late PageController _controller;

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
    _controller = PageController(initialPage: widget.index, keepPage: true);

    final weatherInfo =
        ref.watch(weatherProvider.select((value) => value[widget.index]));

    return CupertinoPageScaffold(
      child: Column(
        children: [
          Expanded(
            child: WeatherPageView(
              controller: _controller,
              imagePath: WeatherModel.weatherImage(weatherInfo),
              itemCount: widget.itemCount,
              child: SafeArea(
                child: Center(child: Text('Data')),
              ),
            ),
          ),
          BottomNavBar(
            controller: _controller,
            itemCount: widget.itemCount,
          ),
        ],
      ),
    );
  }
}

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
    required this.controller,
    required this.itemCount,
  });

  final PageController controller;
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        GestureDetector(
          onTap: () {},
          child: const Icon(
            CupertinoIcons.map,
            color: CupertinoColors.white,
          ),
        ),
        WeatherSmoothIndicator(
          controller: controller,
          count: itemCount,
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(
            CupertinoIcons.list_bullet,
            color: CupertinoColors.white,
          ),
        ),
      ]),
    );
  }
}

class WeatherPageView extends StatelessWidget {
  const WeatherPageView({
    super.key,
    required this.controller,
    required this.imagePath,
    required this.itemCount,
    required this.child,
  });

  final PageController controller;
  final String imagePath;
  final int itemCount;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView.builder(
          controller: controller,
          onPageChanged: (int value) {},
          itemCount: itemCount,
          itemBuilder: (context, index) {
            return Hero(
              tag: 'weather-cart-$index',
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: child,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class WeatherSmoothIndicator extends StatelessWidget {
  const WeatherSmoothIndicator({
    super.key,
    required this.controller,
    required this.count,
  });
  final PageController controller;
  final int count;

  @override
  Widget build(BuildContext context) {
    return SmoothPageIndicator(
      controller: controller,
      count: count,
      onDotClicked: (int value) {},
      effect: const WormEffect(
        dotHeight: 12,
        dotWidth: 12,
        type: WormType.thinUnderground,
        activeDotColor: CupertinoColors.systemGrey6,
        dotColor: CupertinoColors.systemGrey,
      ),
    );
  }
}
