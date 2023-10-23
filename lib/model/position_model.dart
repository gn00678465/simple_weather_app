import 'package:json_annotation/json_annotation.dart';

part 'position_model.g.dart';

@JsonSerializable()
class PositionModel {
  PositionModel({required this.latitude, required this.longitude});

  final double latitude;
  final double longitude;

  factory PositionModel.fromJson(Map<String, dynamic> json) =>
      _$PositionModelFromJson(json);

  Map<String, dynamic> toJson() => _$PositionModelToJson(this);
}
