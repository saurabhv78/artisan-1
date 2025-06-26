import 'package:Artisan/src/models/discount_data/discount_data.dart';
import 'package:Artisan/src/models/media_data/media_data.dart';
import 'package:json_annotation/json_annotation.dart';

import '../artist_data/artist_data.dart';
import '../category_data/category_data.dart';

part 'product_data.g.dart';

@JsonSerializable()
class ProductData {
  @JsonKey(name: 'name')
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
  final CategoryData categoryData;
  @JsonKey(name: 'artist_id')
  final ArtistData artistData;
  @JsonKey(name: 'price')
  final int prodPrice;
  @JsonKey(name: 'prod_similar')
  List<dynamic>? prodSimilar;
  @JsonKey(name: 'prod_media')
  List<MediaData>? prodMedia;
  List<dynamic>? review;
  @JsonKey(name: "discount_id")
  final DiscountData? discountData;

  ProductData({
    required this.prodName,
    required this.prodDesc,
    required this.prodCount,
    required this.totalRating,
    required this.status,
    required this.createdOn,
    required this.updatedOn,
    required this.id,
    required this.categoryData,
    required this.artistData,
    this.prodPrice = 0,
    this.prodSimilar,
    this.prodMedia,
    this.discountData,
    this.review,
  });

  factory ProductData.fromJson(Map<String, dynamic> json) {
    return _$ProductDataFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ProductDataToJson(this);
}
