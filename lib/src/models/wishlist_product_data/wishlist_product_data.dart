// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

part 'wishlist_product_data.g.dart';

@JsonSerializable()
class WishlistProductData {
  @JsonKey(name: 'prod_name')
  final String prodName;
  @JsonKey(name: 'prod_desc')
  final String prodDesc;
  @JsonKey(name: 'prod_count')
  final int prodCount;
  final int totalRating;
  final int status;
  @JsonKey(name: 'created_on')
  final int createdOn;
  @JsonKey(name: 'updated_on')
  final int updatedOn;
  @JsonKey(name: '_id')
  final String id;
  @JsonKey(name: 'cat_id')
  final String catId;
  @JsonKey(name: 'artist_id')
  final String artistId;
  @JsonKey(name: 'prod_price')
  final int prodPrice;
  @JsonKey(name: 'prod_similar')
  List<dynamic>? prodSimilar;
  @JsonKey(name: 'prod_media')
  List<dynamic>? prodMedia;
  List<dynamic>? review;
  bool isRemoved;

  WishlistProductData({
    required this.prodName,
    required this.prodDesc,
    required this.prodCount,
    required this.totalRating,
    required this.status,
    required this.createdOn,
    required this.updatedOn,
    required this.id,
    required this.catId,
    required this.artistId,
    required this.prodPrice,
    this.prodSimilar,
    this.prodMedia,
    this.review,
    this.isRemoved = false,
  });

  factory WishlistProductData.fromJson(Map<String, dynamic> json) {
    return _$WishlistProductDataFromJson(json);
  }

  Map<String, dynamic> toJson() => _$WishlistProductDataToJson(this);

  WishlistProductData copyWith({
    String? prodName,
    String? prodDesc,
    int? prodCount,
    int? totalRating,
    int? status,
    int? createdOn,
    int? updatedOn,
    String? id,
    String? catId,
    String? artistId,
    int? prodPrice,
    List<dynamic>? prodSimilar,
    List<dynamic>? prodMedia,
    List<dynamic>? review,
    bool? isRemoved,
  }) {
    return WishlistProductData(
      prodName: prodName ?? this.prodName,
      prodDesc: prodDesc ?? this.prodDesc,
      prodCount: prodCount ?? this.prodCount,
      totalRating: totalRating ?? this.totalRating,
      status: status ?? this.status,
      createdOn: createdOn ?? this.createdOn,
      updatedOn: updatedOn ?? this.updatedOn,
      id: id ?? this.id,
      catId: catId ?? this.catId,
      artistId: artistId ?? this.artistId,
      prodPrice: prodPrice ?? this.prodPrice,
      prodSimilar: prodSimilar ?? this.prodSimilar,
      prodMedia: prodMedia ?? this.prodMedia,
      review: review ?? this.review,
      isRemoved: isRemoved ?? this.isRemoved,
    );
  }
}
