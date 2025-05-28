// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartData _$CartDataFromJson(Map<String, dynamic> json) => CartData(
      quantity: (json['quantity'] as num).toInt(),
      id: json['_id'] as String,
      prodId: ProdId.fromJson(json['prod_id'] as Map<String, dynamic>),
      discountValue: (json['discount_value'] as num).toInt(),
    );

Map<String, dynamic> _$CartDataToJson(CartData instance) => <String, dynamic>{
      'quantity': instance.quantity,
      '_id': instance.id,
      'prod_id': instance.prodId,
      'discount_value': instance.discountValue,
    };
