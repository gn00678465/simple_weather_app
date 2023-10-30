import 'package:json_annotation/json_annotation.dart';

part 'places_model.g.dart';

@JsonSerializable()
class PlacesModel {
  PlacesModel({
    required this.place_id,
    required this.description,
  });

  final String place_id;
  final String description;

  factory PlacesModel.fromJson(Map<String, dynamic> json) =>
      _$PlacesModelFromJson(json);

  Map<String, dynamic> toJson() => _$PlacesModelToJson(this);
}
