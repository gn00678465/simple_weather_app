import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:simple_weather_app/constants/text_shadow.dart';
import 'package:simple_weather_app/model/weather_model.dart';
import 'package:simple_weather_app/providers/weather_provider.dart';

class WeatherDetail extends ConsumerStatefulWidget {
  final int index;
  final int itemCount;
  final bool isCurrent;

  const WeatherDetail({
    super.key,
    required this.index,
    required this.itemCount,
    this.isCurrent = false,
  });

  @override
  ConsumerState<WeatherDetail> createState() => _WeatherDetail();
}

class _WeatherDetail extends ConsumerState<WeatherDetail>
    with TickerProviderStateMixin {
  late PageController _controller;
  late AnimationController _opacityController;
  Timer? _timer;

  @override
  void initState() {
    _opacityController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    super.initState();

    _runAnimation();
  }

  @override
  void dispose() {
    _opacityController.dispose();
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _runAnimation() {
    _timer = Timer(const Duration(milliseconds: 300), () {
      _opacityController.forward();
    });
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
              child: FadeTransition(
                opacity: _opacityController,
                child: PageViewContent(
                  weatherInfo: weatherInfo,
                  isCurrent: widget.isCurrent,
                ),
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

class PageViewContent extends StatelessWidget {
  const PageViewContent({
    super.key,
    required this.weatherInfo,
    this.isCurrent = false,
  });

  final WeatherModel weatherInfo;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isCurrent ? '我的位置' : weatherInfo.city,
              style: TextStyle(
                color: CupertinoColors.lightBackgroundGray,
                fontSize: 24,
                fontWeight: FontWeight.w500,
                shadows: outlinedText,
              ),
            ),
            Visibility(
              visible: isCurrent,
              child: Text(
                weatherInfo.city,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Text(
              '${weatherInfo.temp}\u00B0',
              style: TextStyle(
                color: CupertinoColors.white,
                fontSize: 72,
                fontWeight: FontWeight.w300,
                shadows: outlinedText,
              ),
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(text: '最高 ${weatherInfo.temp_max}\u00B0'),
                  const WidgetSpan(child: SizedBox(width: 6)),
                  TextSpan(text: '最低 ${weatherInfo.temp_min}\u00B0'),
                ],
                style: TextStyle(
                  color: CupertinoColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  shadows: outlinedText,
                ),
              ),
            ),
            Text(
              weatherInfo.weatherDesc,
              style: TextStyle(
                color: CupertinoColors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                shadows: outlinedText,
              ),
            ),
          ],
        ),
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
                child: child,
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
        dotHeight: 8,
        dotWidth: 8,
        type: WormType.thinUnderground,
        activeDotColor: CupertinoColors.systemGrey6,
        dotColor: CupertinoColors.systemGrey,
      ),
    );
  }
}
