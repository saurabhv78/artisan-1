// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MediaData _$MediaDataFromJson(Map<String, dynamic> json) => MediaData(
      id: json['_id'] as String,
      fileName: json['fileName'] as String,
      mimeType: json['mimeType'] as String,
    );

Map<String, dynamic> _$MediaDataToJson(MediaData instance) => <String, dynamic>{
      '_id': instance.id,
      'fileName': instance.fileName,
      'mimeType': instance.mimeType,
    };
