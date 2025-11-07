import 'package:Artisan/src/models/discount_data/discount_data.dart';
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

  @JsonKey(name: 'auth_certificate')
  final String authCertificate;

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

  @JsonKey(name: 'artist')
  final ArtistInfo? artistData;

  @JsonKey(name: 'price')
  final int prodPrice;
  final String? thumbnail;
  @JsonKey(name: 'prod_similar')
  final List<dynamic>? prodSimilar;

  @JsonKey(name: 'images')
  final List<String> images;

  final List<dynamic>? review;

  @JsonKey(name: 'discount_id')
  final DiscountData? discountData;

  @JsonKey(defaultValue: false)
  final bool isLiked;

  @JsonKey(name: 'baseType', defaultValue: '')
  final String baseType;

  @JsonKey(name: 'PaintingSize', defaultValue: '')
  final String? paintingSize;

  @JsonKey(name: 'paintingType', defaultValue: '')
  final String? paintingType;

  @JsonKey(name: 'signed', defaultValue: false)
  final bool signed;

  @JsonKey(name: 'framed', defaultValue: false)
  final bool framed;

  ProductData({
    this.id = '',
    this.prodName = '',
    this.prodDesc = '',
    this.authCertificate = "",
    this.category = '',
    this.prodCount,
    this.totalRating = 0,
    this.status,
    this.createdOn,
    this.updatedOn,
    this.categoryData,
    this.artistData,
    this.thumbnail,
    this.prodPrice = 0,
    this.prodSimilar,
    this.images = const [],
    this.review,
    this.discountData,
    this.isLiked = false,
    this.baseType = '',
    this.paintingSize = '',
    this.paintingType = '',
    this.signed = false,
    this.framed = false,
  });

  // ---------- copyWith ----------
  ProductData copyWith({
    String? id,
    String? prodName,
    String? prodDesc,
    String? authCertificate,
    String? category,
    int? prodCount,
    int? totalRating,
    int? status,
    int? createdOn,
    int? updatedOn,
    CategoryData? categoryData,
    ArtistInfo? artistData,
    int? prodPrice,
    String? thumbnail,
    List<dynamic>? prodSimilar,
    List<String>? images,
    List<dynamic>? review,
    DiscountData? discountData,
    bool? isLiked,
    String? baseType,
    String? paintingSize,
    String? paintingType,
    bool? signed,
    bool? framed,
  }) {
    return ProductData(
      id: id ?? this.id,
      prodName: prodName ?? this.prodName,
      prodDesc: prodDesc ?? this.prodDesc,
      authCertificate: authCertificate ?? this.authCertificate,
      category: category ?? this.category,
      prodCount: prodCount ?? this.prodCount,
      totalRating: totalRating ?? this.totalRating,
      status: status ?? this.status,
      createdOn: createdOn ?? this.createdOn,
      updatedOn: updatedOn ?? this.updatedOn,
      categoryData: categoryData ?? this.categoryData,
      artistData: artistData ?? this.artistData,
      thumbnail: thumbnail ?? this.thumbnail,
      prodPrice: prodPrice ?? this.prodPrice,
      prodSimilar: prodSimilar ?? this.prodSimilar,
      images: images ?? this.images,
      review: review ?? this.review,
      discountData: discountData ?? this.discountData,
      isLiked: isLiked ?? this.isLiked,
      baseType: baseType ?? this.baseType,
      paintingSize: paintingSize ?? this.paintingSize,
      paintingType: paintingType ?? this.paintingType,
      signed: signed ?? this.signed,
      framed: framed ?? this.framed,
    );
  }

  // ---------- JSON ----------
  factory ProductData.fromJson(Map<String, dynamic> json) =>
      _$ProductDataFromJson(json);

  Map<String, dynamic> toJson() => _$ProductDataToJson(this);
}
