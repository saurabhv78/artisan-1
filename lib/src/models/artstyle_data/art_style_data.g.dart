// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'art_style_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArtStyleResponse _$ArtStyleResponseFromJson(Map<String, dynamic> json) =>
    ArtStyleResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      statusCode: (json['statusCode'] as num).toInt(),
      data: (json['data'] as List<dynamic>)
          .map((e) => ArtStyle.fromJson(e as Map<String, dynamic>))
          .toList(),
      other: OtherMeta.fromJson(json['other'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ArtStyleResponseToJson(ArtStyleResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'statusCode': instance.statusCode,
      'data': instance.data,
      'other': instance.other,
    };

ArtStyle _$ArtStyleFromJson(Map<String, dynamic> json) => ArtStyle(
      id: json['id'] as String,
      name: json['name'] as String,
      file: json['file'] as String,
    );

Map<String, dynamic> _$ArtStyleToJson(ArtStyle instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'file': instance.file,
    };

OtherMeta _$OtherMetaFromJson(Map<String, dynamic> json) => OtherMeta(
      page: (json['page'] as num?)?.toInt(),
      limit: (json['limit'] as num?)?.toInt(),
      skip: (json['skip'] as num?)?.toInt(),
      sort: json['sort'] as String?,
      sortDirection: json['sortDirection'] as String?,
      totalPages: (json['totalPages'] as num?)?.toInt(),
      total: (json['total'] as num?)?.toInt(),
    );

Map<String, dynamic> _$OtherMetaToJson(OtherMeta instance) => <String, dynamic>{
      'page': instance.page,
      'limit': instance.limit,
      'skip': instance.skip,
      'sort': instance.sort,
      'sortDirection': instance.sortDirection,
      'totalPages': instance.totalPages,
      'total': instance.total,
    };
