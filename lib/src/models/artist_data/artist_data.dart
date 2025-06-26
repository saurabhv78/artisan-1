// import 'package:json_annotation/json_annotation.dart';

// part 'artist_data.g.dart';

// @JsonSerializable()
// class ArtistData {
//   final String name;
//   final String image;
//   final String location;
//   final String desc;
//   final int status;
//   @JsonKey(name: 'created_on')
//   final int createdOn;
//   @JsonKey(name: 'updated_on')
//   final int updatedOn;
//   @JsonKey(name: '_id')
//   final String id;

//   ArtistData({
//     required this.name,
//     required this.image,
//     required this.location,
//     required this.desc,
//     required this.status,
//     required this.createdOn,
//     required this.updatedOn,
//     required this.id,
//   });

//   factory ArtistData.fromJson(Map<String, dynamic> json) {
//     return _$ArtistDataFromJson(json);
//   }

//   Map<String, dynamic> toJson() => _$ArtistDataToJson(this);
// }
import 'package:json_annotation/json_annotation.dart';

part 'artist_data.g.dart';

@JsonSerializable()
class TrendingArtistsResponse {
  final bool success;
  final String message;
  final int statusCode;
  final List<ArtistData> data;
  final OtherMeta other;

  TrendingArtistsResponse({
    required this.success,
    required this.message,
    required this.statusCode,
    required this.data,
    required this.other,
  });

  factory TrendingArtistsResponse.fromJson(Map<String, dynamic> json) =>
      _$TrendingArtistsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TrendingArtistsResponseToJson(this);
}

@JsonSerializable()
class ArtistData {
  final String id;
  final String name;
  final ArtistInfo artist;
  final List<String> images;

  ArtistData({
    required this.id,
    required this.name,
    required this.artist,
    required this.images,
  });

  factory ArtistData.fromJson(Map<String, dynamic> json) =>
      _$ArtistDataFromJson(json);

  Map<String, dynamic> toJson() => _$ArtistDataToJson(this);
}

@JsonSerializable()
class ArtistInfo {
  final String? id;
  final String? fullName;
  final String? profilePicture;
  final String? bio;
  final String? createdAt;
  final String? updatedAt;

  ArtistInfo({
     this.id,
     this.fullName,
     this.profilePicture,
     this.bio,
     this.createdAt,
     this.updatedAt,
  });

  factory ArtistInfo.fromJson(Map<String, dynamic> json) =>
      _$ArtistInfoFromJson(json);

  Map<String, dynamic> toJson() => _$ArtistInfoToJson(this);
}

@JsonSerializable()
class OtherMeta {
  final int? page;
  final int? limit;
  final int? skip;
  final String? sort;
  final String? sortDirection;
  final int? totalPages;
  final int? total;

  OtherMeta({
     this.page,
     this.limit,
     this.skip,
     this.sort,
     this.sortDirection,
     this.totalPages,
     this.total,
  });

  factory OtherMeta.fromJson(Map<String, dynamic> json) =>
      _$OtherMetaFromJson(json);

  Map<String, dynamic> toJson() => _$OtherMetaToJson(this);
}
