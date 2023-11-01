import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:simple_weather_app/providers/weather_provider.dart';
import 'package:simple_weather_app/constants/text_shadow.dart';
import 'package:simple_weather_app/model/weather_model.dart';
import 'package:simple_weather_app/views/widgets/fade_in_out.dart';
import 'package:simple_weather_app/views/widgets/sliver_header_delegate.dart';

class WeatherDetail extends ConsumerStatefulWidget {
  final int index;
  final int itemCount;
  final String heroTag;

  const WeatherDetail({
    super.key,
    required this.index,
    required this.itemCount,
    required this.heroTag,
  });

  @override
  ConsumerState<WeatherDetail> createState() => _WeatherDetail();
}

class _WeatherDetail extends ConsumerState<WeatherDetail>
    with TickerProviderStateMixin {
  late int currentPage;
  late PageController _controller;
  late AnimationController _opacityController;
  late String heroTag;

  Timer? _timer;

  int get index => widget.index;
  int get itemCount => widget.itemCount;

  @override
  void initState() {
    _opacityController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _runAnimation();
    _controller = PageController(initialPage: index, keepPage: true);
    heroTag = widget.heroTag;
    currentPage = index;
    super.initState();
  }

  @override
  void dispose() {
    _opacityController.dispose();
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _onPageChanged(int page) {
    heroTag = 'weather-cart-$page';
    setState(() {
      currentPage = page;
    });
  }

  void _runAnimation() {
    _timer = Timer(const Duration(milliseconds: 300), () {
      _opacityController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    final WeatherModel weatherInfo =
        ref.watch(weathersProvider.select((value) => value[currentPage]!));

    return CupertinoPageScaffold(
      child: Column(
        children: [
          Expanded(
            child: Hero(
              tag: heroTag,
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(WeatherModel.weatherImage(weatherInfo)),
                    fit: BoxFit.cover,
                  ),
                ),
                child: WeatherPageView(
                  controller: _controller,
                  itemCount: itemCount,
                  onPageChanged: _onPageChanged,
                  child: FadeTransition(
                    opacity: _opacityController,
                    child: PageViewContent(
                      key: ValueKey(currentPage),
                      weatherInfo: weatherInfo,
                    ),
                  ),
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
  });

  final WeatherModel weatherInfo;

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
                        weatherInfo.currentPosition ? '我的位置' : weatherInfo.city,
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
                        visible: weatherInfo.currentPosition,
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
    required this.itemCount,
    required this.child,
    this.onPageChanged,
  });

  final PageController controller;
  final int itemCount;
  final Widget child;
  final void Function(int)? onPageChanged;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView.builder(
          padEnds: false,
          allowImplicitScrolling: true,
          controller: controller,
          onPageChanged: onPageChanged,
          itemCount: itemCount,
          itemBuilder: (context, index) {
            return child;
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
