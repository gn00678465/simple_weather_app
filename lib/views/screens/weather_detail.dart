import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:simple_weather_app/constants/text_shadow.dart';
import 'package:simple_weather_app/model/weather_model.dart';
import 'package:simple_weather_app/views/widgets/fade_in_out.dart';
import 'package:simple_weather_app/views/widgets/sliver_header_delegate.dart';

class WeatherDetail extends StatefulWidget {
  final int index;
  final int itemCount;
  final bool isCurrent;
  final String heroTag;

  const WeatherDetail({
    super.key,
    required this.index,
    required this.itemCount,
    required this.heroTag,
    this.isCurrent = false,
  });

  @override
  State<WeatherDetail> createState() => _WeatherDetail();
}

class _WeatherDetail extends State<WeatherDetail>
    with TickerProviderStateMixin {
  late PageController _controller;
  late AnimationController _opacityController;
  Timer? _timer;

  String get heroTag => widget.heroTag;
  int get index => widget.index;
  int get itemCount => widget.itemCount;

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
    _controller = PageController(initialPage: index, keepPage: true);

    final WeatherModel weatherInfo =
        ModalRoute.of(context)?.settings.arguments as WeatherModel;

    return CupertinoPageScaffold(
      child: Column(
        children: [
          Expanded(
            child: WeatherPageView(
              heroTag: heroTag,
              controller: _controller,
              imagePath: WeatherModel.weatherImage(weatherInfo),
              itemCount: itemCount,
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
            itemCount: itemCount,
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

  final double minExtent = 36 + 21 + 74 + 18 + 24;
  final double maxExtent = 236;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: <Widget>[
          SliverPersistentHeader(
            pinned: true,
            delegate: SliverHeaderDelegate.builder(
              minHeight: minExtent,
              maxHeight: maxExtent,
              builder: (context, shrinkOffset, overlapsContent) {
                return Center(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Text(
                        isCurrent ? '我的位置' : weatherInfo.city,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: CupertinoColors.lightBackgroundGray,
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          shadows: outlinedText,
                          leadingDistribution: TextLeadingDistribution.even,
                          height: 1.5,
                        ),
                      ),
                      Visibility(
                        visible: isCurrent,
                        child: Text(
                          weatherInfo.city,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            leadingDistribution: TextLeadingDistribution.even,
                            height: 1.5,
                          ),
                        ),
                      ),
                      Text(
                        '${weatherInfo.temp}\u00B0',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: CupertinoColors.white,
                          fontSize: 72,
                          fontWeight: FontWeight.w300,
                          shadows: outlinedText,
                          leadingDistribution: TextLeadingDistribution.even,
                          height: 1,
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
                            leadingDistribution: TextLeadingDistribution.even,
                            height: 1,
                          ),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      FadeInOut(
                        child: Text(
                          weatherInfo.weatherDesc,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: CupertinoColors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            shadows: outlinedText,
                            leadingDistribution: TextLeadingDistribution.even,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
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
    required this.heroTag,
  });

  final PageController controller;
  final String imagePath;
  final int itemCount;
  final Widget child;
  final String heroTag;

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
              tag: heroTag,
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
