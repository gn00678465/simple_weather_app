import 'package:json_annotation/json_annotation.dart';

part 'location_model.g.dart';

@JsonSerializable(explicitToJson: true)
class LocationModel {
  LocationModel({
    required this.name,
    required this.lat,
    required this.lng,
  });

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(readValue: _readValue)
  final double lat;

  @JsonKey(readValue: _readValue)
  final double lng;

  factory LocationModel.fromJson(Map<String, dynamic> json) =>
      _$LocationModelFromJson(json);

  Map<String, dynamic> toJson() => _$LocationModelToJson(this);

  static double _readValue(Map json, String filed) =>
      json[filed] ?? json['geometry']['location'][filed];
}
