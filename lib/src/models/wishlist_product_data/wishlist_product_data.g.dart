// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wishlist_product_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WishlistProductData _$WishlistProductDataFromJson(Map<String, dynamic> json) =>
    WishlistProductData(
      id: json['_id'] as String,
      userId: json['userId'] as String,
      prodId: json['prod_id'] as String,
      prodName: json['prod_name'] as String,
      prodDesc: json['prod_desc'] as String,
      catId: json['cat_id'] as String,
      artistId: json['artist_id'] as String,
      prodPrice: (json['prod_price'] as num).toInt(),
      prodMedia: (json['prod_media'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      review: json['review'] as List<dynamic>? ?? [],
      createdOn: json['created_on'] as String,
      updatedOn: json['updated_on'] as String,
      isRemoved: json['isRemoved'] as bool? ?? false,
    );

Map<String, dynamic> _$WishlistProductDataToJson(
        WishlistProductData instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'userId': instance.userId,
      'prod_id': instance.prodId,
      'prod_name': instance.prodName,
      'prod_desc': instance.prodDesc,
      'cat_id': instance.catId,
      'artist_id': instance.artistId,
      'prod_price': instance.prodPrice,
      'prod_media': instance.prodMedia,
      'review': instance.review,
      'created_on': instance.createdOn,
      'updated_on': instance.updatedOn,
      'isRemoved': instance.isRemoved,
    };
