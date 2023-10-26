import 'dart:core';
import 'package:flutter/cupertino.dart';

import 'package:simple_weather_app/model/weather_model.dart';
import 'package:simple_weather_app/constants/text_shadow.dart';

const Shadow _shadow = Shadow(
  color: CupertinoColors.systemGrey,
  blurRadius: 12.0,
  offset: Offset(0.0, 0.0),
);

class WeatherCard extends StatelessWidget {
  final WeatherModel weatherInfo;
  final int index;
  final bool isMinimized;
  final bool isCurrent;
  final Duration duration = const Duration(milliseconds: 300);
  final String heroTag;
  final void Function()? onTap;

  const WeatherCard({
    super.key,
    required this.index,
    required this.weatherInfo,
    required this.heroTag,
    this.isCurrent = false,
    this.isMinimized = false,
    this.onTap,
  });

  Widget _card() {
    return AnimatedContainer(
      duration: duration,
      height: isMinimized ? 56 : 88,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: AssetImage(WeatherModel.weatherImage(weatherInfo)),
          fit: BoxFit.cover,
          alignment: Alignment.center,
        ),
      ),
      child: Stack(
        children: [
          // 顯示地區
          Positioned(
            left: 0,
            top: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isCurrent ? '我的位置' : weatherInfo.city,
                  style: TextStyle(
                    color: CupertinoColors.systemGrey5,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    shadows: outlinedText,
                  ),
                ),
                Visibility(
                  child: Text(
                    weatherInfo.city,
                    style: const TextStyle(
                      fontSize: 12,
                      color: CupertinoColors.white,
                      shadows: [
                        _shadow,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // 顯示溫度
          Positioned(
            right: 0,
            top: 0,
            child: Text(
              '${weatherInfo.temp}\u00B0',
              style: TextStyle(
                color: CupertinoColors.lightBackgroundGray,
                fontSize: 36,
                shadows: outlinedText,
              ),
            ),
          ),
          // 溫度 range
          Positioned(
            right: 0,
            bottom: 0,
            child: _hideWhenMinimized(
              duration: duration,
              // offstage: isMinimized,
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(text: '最高 ${weatherInfo.temp_max}\u00B0'),
                    const WidgetSpan(child: SizedBox(width: 6)),
                    TextSpan(text: '最低 ${weatherInfo.temp_min}\u00B0'),
                  ],
                  style: const TextStyle(
                    color: CupertinoColors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          // 狀態
          Positioned(
            left: 0,
            bottom: 0,
            child: _hideWhenMinimized(
              duration: duration,
              // offstage: isMinimized,
              child: Text(
                weatherInfo.weatherDesc,
                style: const TextStyle(
                  color: CupertinoColors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: heroTag,
      child: GestureDetector(
        onTap: onTap,
        child: _card(),
      ),
    );
  }

  Widget _hideWhenMinimized(
      {required Widget child, required Duration duration}) {
    final Animation<double> _parent = CurvedAnimation(
      parent: const AlwaysStoppedAnimation(1),
      curve: Curves.easeInOut,
    );

    return AnimatedSwitcher(
      duration: duration,
      child: !isMinimized
          ? FadeTransition(
              key: const ValueKey(1),
              opacity: Tween<double>(begin: 0, end: 1).animate(_parent),
              child: child,
            )
          : FadeTransition(
              key: const ValueKey(2),
              opacity: Tween<double>(begin: 1, end: 0).animate(_parent),
              child: child,
            ),
    );
  }
}
