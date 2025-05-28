// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

import 'prod_id.dart';

part 'cart_data.g.dart';

@JsonSerializable()
class CartData {
  final int quantity;
  @JsonKey(name: '_id')
  final String id;
  @JsonKey(name: 'prod_id')
  final ProdId prodId;
  @JsonKey(name: 'discount_value')
  final int discountValue;

  CartData({
    required this.quantity,
    required this.id,
    required this.prodId,
    required this.discountValue,
  });

  factory CartData.fromJson(Map<String, dynamic> json) {
    return _$CartDataFromJson(json);
  }

  Map<String, dynamic> toJson() => _$CartDataToJson(this);
}
