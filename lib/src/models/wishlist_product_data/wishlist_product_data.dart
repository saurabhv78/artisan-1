// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:json_annotation/json_annotation.dart';

// part 'wishlist_product_data.g.dart';

// @JsonSerializable()
// class WishlistProductData {
//   @JsonKey(name: '_id')
//   final String id;

//   @JsonKey(name: 'prod_name')
//   final String prodName;

//   @JsonKey(name: 'prod_desc')
//   final String prodDesc;

//   @JsonKey(name: 'cat_id')
//   final String catId;

//   @JsonKey(name: 'artist_id')
//   final String artistId;

//   @JsonKey(name: 'prod_price')
//   final int prodPrice;

//   @JsonKey(name: 'prod_media', defaultValue: [])
//   final List<String> prodMedia;

//   @JsonKey(defaultValue: [])
//   final List<dynamic> review;

//   @JsonKey(name: 'created_on')
//   final String createdOn;

//   @JsonKey(name: 'updated_on')
//   final String updatedOn;

//   @JsonKey(defaultValue: false)
//   final bool isRemoved;

//   WishlistProductData({
//     required this.id,
//     required this.prodName,
//     required this.prodDesc,
//     required this.catId,
//     required this.artistId,
//     required this.prodPrice,
//     this.prodMedia = const [],
//     this.review = const [],
//     required this.createdOn,
//     required this.updatedOn,
//     this.isRemoved = false,
//   });

//   factory WishlistProductData.fromJson(Map<String, dynamic> json) =>
//       _$WishlistProductDataFromJson(json);

//   Map<String, dynamic> toJson() => _$WishlistProductDataToJson(this);

//   WishlistProductData copyWith({
//     String? id,
//     String? prodName,
//     String? prodDesc,
//     String? catId,
//     String? artistId,
//     int? prodPrice,
//     List<String>? prodMedia,
//     List<dynamic>? review,
//     String? createdOn,
//     String? updatedOn,
//     bool? isRemoved,
//   }) {
//     return WishlistProductData(
//       id: id ?? this.id,
//       prodName: prodName ?? this.prodName,
//       prodDesc: prodDesc ?? this.prodDesc,
//       catId: catId ?? this.catId,
//       artistId: artistId ?? this.artistId,
//       prodPrice: prodPrice ?? this.prodPrice,
//       prodMedia: prodMedia ?? this.prodMedia,
//       review: review ?? this.review,
//       createdOn: createdOn ?? this.createdOn,
//       updatedOn: updatedOn ?? this.updatedOn,
//       isRemoved: isRemoved ?? this.isRemoved,
//     );
//   }
// }
// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

part 'wishlist_product_data.g.dart';

@JsonSerializable()
class WishlistProductData {
  @JsonKey(name: '_id')
  final String id; // Wishlist entry ID

  @JsonKey(name: 'userId')
  final String userId;

  @JsonKey(name: 'prod_id')
  final String prodId; // Product ID

  @JsonKey(name: 'prod_name')
  final String prodName;

  @JsonKey(name: 'prod_desc')
  final String prodDesc;

  @JsonKey(name: 'cat_id')
  final String catId;

  @JsonKey(name: 'artist_id')
  final String artistId;

  @JsonKey(name: 'prod_price')
  final int prodPrice;

  @JsonKey(name: 'prod_media', defaultValue: [])
  final List<String> prodMedia;

  @JsonKey(defaultValue: [])
  final List<dynamic> review;

  @JsonKey(name: 'created_on')
  final String createdOn;

  @JsonKey(name: 'updated_on')
  final String updatedOn;

  @JsonKey(defaultValue: false)
  final bool isRemoved;

  WishlistProductData({
    required this.id,
    required this.userId,
    required this.prodId,
    required this.prodName,
    required this.prodDesc,
    required this.catId,
    required this.artistId,
    required this.prodPrice,
    this.prodMedia = const [],
    this.review = const [],
    required this.createdOn,
    required this.updatedOn,
    this.isRemoved = false,
  });

  factory WishlistProductData.fromJson(Map<String, dynamic> json) =>
      _$WishlistProductDataFromJson(json);

  Map<String, dynamic> toJson() => _$WishlistProductDataToJson(this);

  WishlistProductData copyWith({
    String? id,
    String? userId,
    String? prodId,
    String? prodName,
    String? prodDesc,
    String? catId,
    String? artistId,
    int? prodPrice,
    List<String>? prodMedia,
    List<dynamic>? review,
    String? createdOn,
    String? updatedOn,
    bool? isRemoved,
  }) {
    return WishlistProductData(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      prodId: prodId ?? this.prodId,
      prodName: prodName ?? this.prodName,
      prodDesc: prodDesc ?? this.prodDesc,
      catId: catId ?? this.catId,
      artistId: artistId ?? this.artistId,
      prodPrice: prodPrice ?? this.prodPrice,
      prodMedia: prodMedia ?? this.prodMedia,
      review: review ?? this.review,
      createdOn: createdOn ?? this.createdOn,
      updatedOn: updatedOn ?? this.updatedOn,
      isRemoved: isRemoved ?? this.isRemoved,
    );
  }
}
