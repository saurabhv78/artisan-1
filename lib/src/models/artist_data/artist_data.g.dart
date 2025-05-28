// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artist_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArtistData _$ArtistDataFromJson(Map<String, dynamic> json) => ArtistData(
      name: json['name'] as String,
      image: json['image'] as String,
      location: json['location'] as String,
      desc: json['desc'] as String,
      status: (json['status'] as num).toInt(),
      createdOn: (json['created_on'] as num).toInt(),
      updatedOn: (json['updated_on'] as num).toInt(),
      id: json['_id'] as String,
    );

Map<String, dynamic> _$ArtistDataToJson(ArtistData instance) =>
    <String, dynamic>{
      'name': instance.name,
      'image': instance.image,
      'location': instance.location,
      'desc': instance.desc,
      'status': instance.status,
      'created_on': instance.createdOn,
      'updated_on': instance.updatedOn,
      '_id': instance.id,
    };
