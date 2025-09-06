// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CartDataImpl _$$CartDataImplFromJson(Map<String, dynamic> json) =>
    _$CartDataImpl(
      id: json['id'] as String? ?? '',
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => CartItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      pricing: json['pricing'] == null
          ? null
          : Pricing.fromJson(json['pricing'] as Map<String, dynamic>),
      createdAt: json['createdAt'] as String?,
    );

Map<String, dynamic> _$$CartDataImplToJson(_$CartDataImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'items': instance.items,
      'pricing': instance.pricing,
      'createdAt': instance.createdAt,
    };

_$CartItemImpl _$$CartItemImplFromJson(Map<String, dynamic> json) =>
    _$CartItemImpl(
      id: json['id'] as String? ?? '',
      name: json['name'] as String?,
      image: json['image'] as String?,
      price: json['price'] as num?,
      quantity: (json['quantity'] as num?)?.toInt(),
      discountAmt: json['discountAmt'] as num?,
      totalPrice: json['totalPrice'] as num?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$$CartItemImplToJson(_$CartItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image': instance.image,
      'price': instance.price,
      'quantity': instance.quantity,
      'discountAmt': instance.discountAmt,
      'totalPrice': instance.totalPrice,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };

_$PricingImpl _$$PricingImplFromJson(Map<String, dynamic> json) =>
    _$PricingImpl(
      subtotal: json['subtotal'] as num?,
      tax: json['tax'] as num?,
      discount: json['discount'] as num?,
      total: json['total'] as num?,
      ShippingAmount: json['ShippingAmount'] as num?,
      taxPercentage: json['taxPercentage'] as num?,
    );

Map<String, dynamic> _$$PricingImplToJson(_$PricingImpl instance) =>
    <String, dynamic>{
      'subtotal': instance.subtotal,
      'tax': instance.tax,
      'discount': instance.discount,
      'total': instance.total,
      'ShippingAmount': instance.ShippingAmount,
      'taxPercentage': instance.taxPercentage,
    };
