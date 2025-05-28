// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

part 'cart_product_data.g.dart';

@JsonSerializable()
class UpdateCartDataRequest {
  final String addRemove;
  @JsonKey(name: 'cart_data')
  final String cartData;
  UpdateCartDataRequest({
    required this.addRemove,
    required this.cartData,
  });
  factory UpdateCartDataRequest.fromJson(Map<String, dynamic> json) {
    return _$UpdateCartDataRequestFromJson(json);
  }

  Map<String, dynamic> toJson() => _$UpdateCartDataRequestToJson(this);
}

@JsonSerializable()
class CartProductData {
  @JsonKey(name: 'prod_id')
  String? prodId;
  @JsonKey(name: 'discount_value')
  int? discountValue;

  CartProductData({this.prodId, this.discountValue});

  factory CartProductData.fromJson(Map<String, dynamic> json) {
    return _$CartProductDataFromJson(json);
  }

  Map<String, dynamic> toJson() => _$CartProductDataToJson(this);
}
