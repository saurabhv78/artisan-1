// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

part 'prod_id.g.dart';

@JsonSerializable()
class ProdId {
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
  @JsonKey(name: 'discount_id')
  final String? discountId;
  @JsonKey(name: 'prod_price')
  final int prodPrice;
  @JsonKey(name: 'prod_media')
  final List<dynamic>? prodMedia;
  @JsonKey(name: 'prod_similar')
  final List<dynamic>? prodSimilar;
  final List<dynamic>? review;
  ProdId({
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
    this.discountId,
    required this.prodPrice,
    this.prodMedia,
    this.prodSimilar,
    this.review,
  });

  factory ProdId.fromJson(Map<String, dynamic> json) {
    return _$ProdIdFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ProdIdToJson(this);
}
