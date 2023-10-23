// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'position_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PositionModel _$PositionModelFromJson(Map<String, dynamic> json) =>
    PositionModel(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );

Map<String, dynamic> _$PositionModelToJson(PositionModel instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
