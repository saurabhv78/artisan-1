// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wishlist_product_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WishlistProductData _$WishlistProductDataFromJson(Map<String, dynamic> json) =>
    WishlistProductData(
      prodName: json['prod_name'] as String,
      prodDesc: json['prod_desc'] as String,
      prodCount: (json['prod_count'] as num).toInt(),
      totalRating: (json['totalRating'] as num).toInt(),
      status: (json['status'] as num).toInt(),
      createdOn: (json['created_on'] as num).toInt(),
      updatedOn: (json['updated_on'] as num).toInt(),
      id: json['_id'] as String,
      catId: json['cat_id'] as String,
      artistId: json['artist_id'] as String,
      prodPrice: (json['prod_price'] as num).toInt(),
      prodSimilar: json['prod_similar'] as List<dynamic>?,
      prodMedia: json['prod_media'] as List<dynamic>?,
      review: json['review'] as List<dynamic>?,
      isRemoved: json['isRemoved'] as bool? ?? false,
    );

Map<String, dynamic> _$WishlistProductDataToJson(
        WishlistProductData instance) =>
    <String, dynamic>{
      'prod_name': instance.prodName,
      'prod_desc': instance.prodDesc,
      'prod_count': instance.prodCount,
      'totalRating': instance.totalRating,
      'status': instance.status,
      'created_on': instance.createdOn,
      'updated_on': instance.updatedOn,
      '_id': instance.id,
      'cat_id': instance.catId,
      'artist_id': instance.artistId,
      'prod_price': instance.prodPrice,
      'prod_similar': instance.prodSimilar,
      'prod_media': instance.prodMedia,
      'review': instance.review,
      'isRemoved': instance.isRemoved,
    };
