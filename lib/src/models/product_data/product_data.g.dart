// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductData _$ProductDataFromJson(Map<String, dynamic> json) => ProductData(
      prodName: json['prod_name'] as String,
      prodDesc: json['prod_desc'] as String,
      prodCount: (json['prod_count'] as num).toInt(),
      totalRating: (json['totalRating'] as num).toInt(),
      status: (json['status'] as num).toInt(),
      createdOn: (json['created_on'] as num).toInt(),
      updatedOn: (json['updated_on'] as num).toInt(),
      id: json['_id'] as String,
      categoryData:
          CategoryData.fromJson(json['cat_id'] as Map<String, dynamic>),
      artistData:
          ArtistData.fromJson(json['artist_id'] as Map<String, dynamic>),
      prodPrice: (json['prod_price'] as num).toInt(),
      prodSimilar: json['prod_similar'] as List<dynamic>?,
      prodMedia: (json['prod_media'] as List<dynamic>?)
          ?.map((e) => MediaData.fromJson(e as Map<String, dynamic>))
          .toList(),
      discountData: json['discount_id'] == null
          ? null
          : DiscountData.fromJson(json['discount_id'] as Map<String, dynamic>),
      review: json['review'] as List<dynamic>?,
    );

Map<String, dynamic> _$ProductDataToJson(ProductData instance) =>
    <String, dynamic>{
      'prod_name': instance.prodName,
      'prod_desc': instance.prodDesc,
      'prod_count': instance.prodCount,
      'totalRating': instance.totalRating,
      'status': instance.status,
      'created_on': instance.createdOn,
      'updated_on': instance.updatedOn,
      '_id': instance.id,
      'cat_id': instance.categoryData,
      'artist_id': instance.artistData,
      'prod_price': instance.prodPrice,
      'prod_similar': instance.prodSimilar,
      'prod_media': instance.prodMedia,
      'review': instance.review,
      'discount_id': instance.discountData,
    };
