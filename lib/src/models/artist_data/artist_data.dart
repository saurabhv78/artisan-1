import 'package:json_annotation/json_annotation.dart';

part 'artist_data.g.dart';

@JsonSerializable()
class ArtistData {
  final String name;
  final String image;
  final String location;
  final String desc;
  final int status;
  @JsonKey(name: 'created_on')
  final int createdOn;
  @JsonKey(name: 'updated_on')
  final int updatedOn;
  @JsonKey(name: '_id')
  final String id;

  ArtistData({
    required this.name,
    required this.image,
    required this.location,
    required this.desc,
    required this.status,
    required this.createdOn,
    required this.updatedOn,
    required this.id,
  });

  factory ArtistData.fromJson(Map<String, dynamic> json) {
    return _$ArtistDataFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ArtistDataToJson(this);
}
