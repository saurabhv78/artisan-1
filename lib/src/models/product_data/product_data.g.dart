// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductData _$ProductDataFromJson(Map<String, dynamic> json) => ProductData(
      id: json['id'] as String? ?? '',
      prodName: json['name'] as String? ?? '',
      prodDesc: json['description'] as String? ?? '',
      authCertificate: json['auth_certificate'] as String? ?? "",
      category: json['category'] as String? ?? '',
      prodCount: (json['prod_count'] as num?)?.toInt(),
      totalRating: (json['totalRating'] as num?)?.toInt() ?? 0,
      status: (json['status'] as num?)?.toInt(),
      createdOn: (json['created_on'] as num?)?.toInt(),
      updatedOn: (json['updated_on'] as num?)?.toInt(),
      categoryData: json['cat_id'] == null
          ? null
          : CategoryData.fromJson(json['cat_id'] as Map<String, dynamic>),
      artistData: json['artist'] == null
          ? null
          : ArtistInfo.fromJson(json['artist'] as Map<String, dynamic>),
      prodPrice: (json['price'] as num?)?.toInt() ?? 0,
      prodSimilar: json['prod_similar'] as List<dynamic>?,
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      review: json['review'] as List<dynamic>?,
      discountData: json['discount_id'] == null
          ? null
          : DiscountData.fromJson(json['discount_id'] as Map<String, dynamic>),
      isLiked: json['isLiked'] as bool? ?? false,
      baseType: json['baseType'] as String? ?? '',
      paintingSize: json['PaintingSize'] as String? ?? '',
      paintingType: json['paintingType'] as String? ?? '',
      signed: json['signed'] as bool? ?? false,
      framed: json['framed'] as bool? ?? false,
    );

Map<String, dynamic> _$ProductDataToJson(ProductData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.prodName,
      'description': instance.prodDesc,
      'auth_certificate': instance.authCertificate,
      'category': instance.category,
      'prod_count': instance.prodCount,
      'totalRating': instance.totalRating,
      'status': instance.status,
      'created_on': instance.createdOn,
      'updated_on': instance.updatedOn,
      'cat_id': instance.categoryData,
      'artist': instance.artistData,
      'price': instance.prodPrice,
      'prod_similar': instance.prodSimilar,
      'images': instance.images,
      'review': instance.review,
      'discount_id': instance.discountData,
      'isLiked': instance.isLiked,
      'baseType': instance.baseType,
      'PaintingSize': instance.paintingSize,
      'paintingType': instance.paintingType,
      'signed': instance.signed,
      'framed': instance.framed,
    };
