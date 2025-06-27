// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discount_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DiscountData _$DiscountDataFromJson(Map<String, dynamic> json) => DiscountData(
      discountVal: (json['discount_val'] as num).toInt(),
      discountName: json['discount_name'] as String?,
      createdOn: json['created_on'] as String?,
      updatedOn: json['updated_on'] as String?,
      id: json['_id'] as String?,
      discountImage: json['discount_image'] as String?,
    );

Map<String, dynamic> _$DiscountDataToJson(DiscountData instance) =>
    <String, dynamic>{
      'discount_val': instance.discountVal,
      'discount_name': instance.discountName,
      'created_on': instance.createdOn,
      'updated_on': instance.updatedOn,
      '_id': instance.id,
      'discount_image': instance.discountImage,
    };
