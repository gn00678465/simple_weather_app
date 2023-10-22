// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherModel _$WeatherModelFromJson(Map<String, dynamic> json) => WeatherModel(
      city: json['name'] as String,
      temp: json['temp'] as int,
      temp_max: json['temp_max'] as int,
      temp_min: json['temp_min'] as int,
      feels_like: json['feels_like'] as int,
      pressure: json['pressure'] as int,
      humidity: json['humidity'] as int,
      visibility: json['visibility'] as int,
      weather: json['weather'] as String,
      weatherDesc: json['weatherDesc'] as String,
      windSpeed: (json['windSpeed'] as num).toDouble(),
      windDeg: json['windDeg'] as int,
      sunrise: json['sunrise'] as int,
      sunset: json['sunset'] as int,
      country: json['country'] as String,
      clouds: json['clouds'] as int,
      coord: CoordModel.fromJson(json['coord'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WeatherModelToJson(WeatherModel instance) =>
    <String, dynamic>{
      'name': instance.city,
      'temp': instance.temp,
      'feels_like': instance.feels_like,
      'temp_min': instance.temp_min,
      'temp_max': instance.temp_max,
      'pressure': instance.pressure,
      'humidity': instance.humidity,
      'visibility': instance.visibility,
      'weather': instance.weather,
      'weatherDesc': instance.weatherDesc,
      'windSpeed': instance.windSpeed,
      'windDeg': instance.windDeg,
      'sunrise': instance.sunrise,
      'sunset': instance.sunset,
      'country': instance.country,
      'clouds': instance.clouds,
      'coord': instance.coord,
    };

CoordModel _$CoordModelFromJson(Map<String, dynamic> json) => CoordModel(
      lon: (json['lon'] as num).toDouble(),
      lat: (json['lat'] as num).toDouble(),
    );

Map<String, dynamic> _$CoordModelToJson(CoordModel instance) =>
    <String, dynamic>{
      'lon': instance.lon,
      'lat': instance.lat,
    };
