// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prod_id.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProdId _$ProdIdFromJson(Map<String, dynamic> json) => ProdId(
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
      discountId: json['discount_id'] as String?,
      prodPrice: (json['prod_price'] as num).toInt(),
      prodMedia: json['prod_media'] as List<dynamic>?,
      prodSimilar: json['prod_similar'] as List<dynamic>?,
      review: json['review'] as List<dynamic>?,
    );

Map<String, dynamic> _$ProdIdToJson(ProdId instance) => <String, dynamic>{
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
      'discount_id': instance.discountId,
      'prod_price': instance.prodPrice,
      'prod_media': instance.prodMedia,
      'prod_similar': instance.prodSimilar,
      'review': instance.review,
    };
