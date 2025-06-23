// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'featured_product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeaturedProduct _$FeaturedProductFromJson(Map<String, dynamic> json) =>
    FeaturedProduct(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toInt(),
      quantity: (json['quantity'] as num).toInt(),
      artist:
          FeaturedArtistData.fromJson(json['artist'] as Map<String, dynamic>),
      images:
          (json['images'] as List<dynamic>).map((e) => e as String).toList(),
      reviews:
          (json['reviews'] as List<dynamic>).map((e) => e as String).toList(),
      discount:
          (json['discount'] as List<dynamic>).map((e) => e as String).toList(),
      taxAmount: (json['taxAmount'] as num).toInt(),
      discountAmount: (json['discountAmount'] as num).toInt(),
      payableAmount: (json['payableAmount'] as num).toInt(),
      createdBy: json['createdBy'] as String,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );

Map<String, dynamic> _$FeaturedProductToJson(FeaturedProduct instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'quantity': instance.quantity,
      'artist': instance.artist,
      'images': instance.images,
      'reviews': instance.reviews,
      'discount': instance.discount,
      'taxAmount': instance.taxAmount,
      'discountAmount': instance.discountAmount,
      'payableAmount': instance.payableAmount,
      'createdBy': instance.createdBy,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
