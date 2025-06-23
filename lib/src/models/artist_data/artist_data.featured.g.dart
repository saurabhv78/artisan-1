// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artist_data.featured.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeaturedArtistData _$FeaturedArtistDataFromJson(Map<String, dynamic> json) =>
    FeaturedArtistData(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );

Map<String, dynamic> _$FeaturedArtistDataToJson(FeaturedArtistData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fullName': instance.fullName,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
