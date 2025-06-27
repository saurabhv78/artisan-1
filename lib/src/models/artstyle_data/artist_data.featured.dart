import 'package:json_annotation/json_annotation.dart';

part 'artist_data.featured.g.dart';

@JsonSerializable()
class FeaturedArtistData {
  final String id;
  final String fullName;
  final String createdAt;
  final String updatedAt;

  FeaturedArtistData({
    required this.id,
    required this.fullName,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FeaturedArtistData.fromJson(Map<String, dynamic> json) => _$FeaturedArtistDataFromJson(json);
  Map<String, dynamic> toJson() => _$FeaturedArtistDataToJson(this);
}
