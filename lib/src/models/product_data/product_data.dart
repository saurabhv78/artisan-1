import 'package:Artisan/src/models/discount_data/discount_data.dart';
import 'package:Artisan/src/models/media_data/media_data.dart';
import 'package:json_annotation/json_annotation.dart';

import '../artist_data/artist_data.dart';
import '../category_data/category_data.dart';

part 'product_data.g.dart';

@JsonSerializable()
class ProductData {
  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'name')
  final String prodName;
  @JsonKey(name: 'description')
  final String prodDesc;
  @JsonKey(name: 'category')
  final String category;
  @JsonKey(name: 'prod_count')
  final int? prodCount;
  final int totalRating;
  final int? status;
  @JsonKey(name: 'created_on')
  final int? createdOn;
  @JsonKey(name: 'updated_on')
  final int? updatedOn;
  @JsonKey(name: 'cat_id')
  final CategoryData? categoryData;
  @JsonKey(name: 'artist_id')
  final ArtistData? artistData;
  @JsonKey(name: 'price')
  final int prodPrice;
  @JsonKey(name: 'prod_similar')
  List<dynamic>? prodSimilar;
  @JsonKey(name: 'images')
  List<String> images;
  List<dynamic>? review;
  @JsonKey(name: "discount_id")
  final DiscountData? discountData;

  ProductData({
    this.prodName = '',
    this.prodDesc = '',
    this.prodCount,
    this.totalRating = 0,
    this.status,
    this.createdOn,
    this.updatedOn,
    this.id = '',
    this.category = '',
    this.categoryData,
    this.artistData,
    this.prodPrice = 0,
    this.prodSimilar,
    this.images = const [],
    this.discountData,
    this.review,
  });

  factory ProductData.fromJson(Map<String, dynamic> json) {
    return _$ProductDataFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ProductDataToJson(this);
}
