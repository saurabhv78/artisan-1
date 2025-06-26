import 'package:json_annotation/json_annotation.dart';

import '../artist_data/artist_data.featured.dart';

part 'featured_product.g.dart';

@JsonSerializable()
class FeaturedProduct {
  final String? id;
  final String? name;
  final String? description;
  final int? price;
  final int? quantity;
  final FeaturedArtistData? artist;
  final List<String> images;
  final List<String> reviews;
  final List<String> discount;
  final int? taxAmount;
  final int? discountAmount;
  final int? payableAmount;
  final String? createdBy;
  final String? createdAt;
  final String? updatedAt;

  FeaturedProduct({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.artist,
     this.images = const [],
     this.reviews = const [],
     this.discount = const [],
    required this.taxAmount,
    required this.discountAmount,
    required this.payableAmount,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FeaturedProduct.fromJson(Map<String, dynamic> json) => _$FeaturedProductFromJson(json);
  Map<String, dynamic> toJson() => _$FeaturedProductToJson(this);
}
