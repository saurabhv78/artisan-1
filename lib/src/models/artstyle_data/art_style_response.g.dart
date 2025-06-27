// // GENERATED CODE - DO NOT MODIFY BY HAND

// part of 'art_style_response.g.dart';

// // **************************************************************************
// // JsonSerializableGenerator
// // **************************************************************************

// TrendingArtistsResponse _$TrendingArtistsResponseFromJson(
//         Map<String, dynamic> json) =>
//     TrendingArtistsResponse(
//       success: json['success'] as bool,
//       message: json['message'] as String,
//       statusCode: (json['statusCode'] as num).toInt(),
//       data: (json['data'] as List<dynamic>)
//           .map((e) => ArtistData.fromJson(e as Map<String, dynamic>))
//           .toList(),
//       other: OtherMeta.fromJson(json['other'] as Map<String, dynamic>),
//     );

// Map<String, dynamic> _$TrendingArtistsResponseToJson(
//         TrendingArtistsResponse instance) =>
//     <String, dynamic>{
//       'success': instance.success,
//       'message': instance.message,
//       'statusCode': instance.statusCode,
//       'data': instance.data,
//       'other': instance.other,
//     };

// ArtistData _$ArtistDataFromJson(Map<String, dynamic> json) => ArtistData(
//       id: json['id'] as String,
//       name: json['name'] as String,
//       artist: ArtistInfo.fromJson(json['artist'] as Map<String, dynamic>),
//       images:
//           (json['images'] as List<dynamic>).map((e) => e as String).toList(),
//     );

// Map<String, dynamic> _$ArtistDataToJson(ArtistData instance) =>
//     <String, dynamic>{
//       'id': instance.id,
//       'name': instance.name,
//       'artist': instance.artist,
//       'images': instance.images,
//     };

// ArtistInfo _$ArtistInfoFromJson(Map<String, dynamic> json) => ArtistInfo(
//       id: json['id'] as String?,
//       fullName: json['fullName'] as String?,
//       profilePicture: json['profilePicture'] as String?,
//       bio: json['bio'] as String?,
//       createdAt: json['createdAt'] as String?,
//       updatedAt: json['updatedAt'] as String?,
//     );

// Map<String, dynamic> _$ArtistInfoToJson(ArtistInfo instance) =>
//     <String, dynamic>{
//       'id': instance.id,
//       'fullName': instance.fullName,
//       'profilePicture': instance.profilePicture,
//       'bio': instance.bio,
//       'createdAt': instance.createdAt,
//       'updatedAt': instance.updatedAt,
//     };

// OtherMeta _$OtherMetaFromJson(Map<String, dynamic> json) => OtherMeta(
//       page: (json['page'] as num?)?.toInt(),
//       limit: (json['limit'] as num?)?.toInt(),
//       skip: (json['skip'] as num?)?.toInt(),
//       sort: json['sort'] as String?,
//       sortDirection: json['sortDirection'] as String?,
//       totalPages: (json['totalPages'] as num?)?.toInt(),
//       total: (json['total'] as num?)?.toInt(),
//     );

// Map<String, dynamic> _$OtherMetaToJson(OtherMeta instance) => <String, dynamic>{
//       'page': instance.page,
//       'limit': instance.limit,
//       'skip': instance.skip,
//       'sort': instance.sort,
//       'sortDirection': instance.sortDirection,
//       'totalPages': instance.totalPages,
//       'total': instance.total,
//     };
