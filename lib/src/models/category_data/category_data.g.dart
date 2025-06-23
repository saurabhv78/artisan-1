// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryData _$CategoryDataFromJson(Map<String, dynamic> json) => CategoryData(
      catName: json['cat_name'] as String,
      createdOn: json['created_on'] as String,
      updatedOn: json['updated_on'] as String?,
      id: json['_id'] as String,
      catImage: json['cat_image'] as String,
    );

Map<String, dynamic> _$CategoryDataToJson(CategoryData instance) =>
    <String, dynamic>{
      'cat_name': instance.catName,
      'created_on': instance.createdOn,
      'updated_on': instance.updatedOn,
      '_id': instance.id,
      'cat_image': instance.catImage,
    };
