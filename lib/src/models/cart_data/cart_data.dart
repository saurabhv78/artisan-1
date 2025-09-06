// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart_data.freezed.dart';
part 'cart_data.g.dart';

@freezed
class CartData with _$CartData {
  const factory CartData({
    @Default('') String id,
    @Default([]) List<CartItem> items,
    Pricing? pricing,
    String? createdAt,
  }) = _CartData;

  factory CartData.fromJson(Map<String, dynamic> json) =>
      _$CartDataFromJson(json);
}

@freezed
class CartItem with _$CartItem {
  const factory CartItem({
    @Default('') String id,
    String? name,
    String? image,
    num? price,
    int? quantity,
    num? discountAmt,
    num? totalPrice,
    String? createdAt,
    String? updatedAt,
  }) = _CartItem;

  factory CartItem.fromJson(Map<String, dynamic> json) =>
      _$CartItemFromJson(json);
}

@freezed
class Pricing with _$Pricing {
  const factory Pricing(
      {num? subtotal,
      num? tax,
      num? discount,
      num? total,
      num? ShippingAmount,
      num? taxPercentage}) = _Pricing;

  factory Pricing.fromJson(Map<String, dynamic> json) =>
      _$PricingFromJson(json);
}
