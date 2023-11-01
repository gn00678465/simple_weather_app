import 'package:json_annotation/json_annotation.dart';

part 'weather_model.g.dart';

@JsonSerializable()
class WeatherModel {
  @JsonKey(name: 'name')
  final String city;

  final int temp; // 溫度
  final int feels_like; // 體感
  final int temp_min; // 最低溫度
  final int temp_max; // 最高溫度
  final int pressure; // 壓力
  final int humidity; // 濕度
  final int visibility; // 能見度
  final String weather; // 天氣狀態
  final String weatherDesc; // 狀態描述
  final double windSpeed; // 風速
  final int windDeg; // 風向
  final int sunrise; // 日出時間
  final int sunset; // 日落時間
  final String country; //
  final int clouds; // 雲量 %
  final CoordModel coord; // 經緯度資訊

  late bool currentPosition;

  WeatherModel({
    required this.city,
    required this.temp,
    required this.temp_max,
    required this.temp_min,
    required this.feels_like,
    required this.pressure,
    required this.humidity,
    required this.visibility,
    required this.weather,
    required this.weatherDesc,
    required this.windSpeed,
    required this.windDeg,
    required this.sunrise,
    required this.sunset,
    required this.country,
    required this.clouds,
    required this.coord,
  }) {
    currentPosition = false;
  }

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      city: json['name'] as String,
      temp: (json['main']['temp'] as num).toDouble().floor(),
      temp_max: (json['main']['temp_max'] as num).toDouble().floor(),
      temp_min: (json['main']['temp_min'] as num).toDouble().floor(),
      feels_like: (json['main']['feels_like'] as num).toDouble().floor(),
      pressure: json['main']['pressure'] as int,
      humidity: json['main']['humidity'] as int,
      visibility: json['visibility'] as int,
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      windDeg: json['wind']['deg'] as int,
      sunrise: json['sys']['sunrise'] as int,
      sunset: json['sys']['sunset'] as int,
      country: json['sys']['country'] as String,
      clouds: json['clouds']['all'] as int,
      weather: json['weather'][0]['main'] as String,
      weatherDesc: json['weather'][0]['description'] as String,
      coord: CoordModel.fromJson(json['coord'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => _$WeatherModelToJson(this);

  static String weatherImage(WeatherModel weather) {
    final now = DateTime.now().toUtc();
    int t = (now.millisecondsSinceEpoch / 1000).ceil();

    if (t > weather.sunrise && t < weather.sunset) {
      if (weather.weather == 'Clouds') {
        return 'assets/images/cloudy.png';
      } else {
        return 'assets/images/sunny.png';
      }
    } else {
      return 'assets/images/night.png';
    }
  }
}

@JsonSerializable()
class CoordModel {
  final double lon;
  final double lat;

  CoordModel({
    required this.lon,
    required this.lat,
  });

  factory CoordModel.fromJson(Map<String, dynamic> json) =>
      _$CoordModelFromJson(json);

  Map<String, dynamic> toJson() => _$CoordModelToJson(this);
}
