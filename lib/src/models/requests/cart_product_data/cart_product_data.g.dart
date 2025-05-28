// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_product_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateCartDataRequest _$UpdateCartDataRequestFromJson(
        Map<String, dynamic> json) =>
    UpdateCartDataRequest(
      addRemove: json['addRemove'] as String,
      cartData: json['cart_data'] as String,
    );

Map<String, dynamic> _$UpdateCartDataRequestToJson(
        UpdateCartDataRequest instance) =>
    <String, dynamic>{
      'addRemove': instance.addRemove,
      'cart_data': instance.cartData,
    };

CartProductData _$CartProductDataFromJson(Map<String, dynamic> json) =>
    CartProductData(
      prodId: json['prod_id'] as String?,
      discountValue: (json['discount_value'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CartProductDataToJson(CartProductData instance) =>
    <String, dynamic>{
      'prod_id': instance.prodId,
      'discount_value': instance.discountValue,
    };
