// import 'package:json_annotation/json_annotation.dart';

// part 'discount_data.g.dart';

// @JsonSerializable()
// class DiscountData {
//   @JsonKey(name: 'discount_val')
//   final int discountVal;

//   @JsonKey(name: 'discount_name')
//   final String? discountName;

//   @JsonKey(name: 'created_on')
//   final String? createdOn;

//   @JsonKey(name: 'updated_on')
//   final String? updatedOn;

//   @JsonKey(name: '_id')
//   final String? id;

//   @JsonKey(name: 'discount_image')
//   final String? discountImage;

//   DiscountData({
//     required this.discountVal,
//     this.discountName,
//     this.createdOn,
//     this.updatedOn,
//     this.id,
//     this.discountImage,
//   });

//   factory DiscountData.fromJson(Map<String, dynamic> json) =>
//       _$DiscountDataFromJson(json);

//   Map<String, dynamic> toJson() => _$DiscountDataToJson(this);
// }
import 'package:json_annotation/json_annotation.dart';

part 'discount_data.g.dart';

@JsonSerializable()
class DiscountData {
  @JsonKey(name: 'discount_val')
  final int discountVal;

  @JsonKey(name: 'discount_name')
  final String? discountName;

  @JsonKey(name: 'created_on')
  final String? createdOn;

  @JsonKey(name: 'updated_on')
  final String? updatedOn;

  @JsonKey(name: 'id') // ✅ fixed key name
  final String? id;

  @JsonKey(name: 'discount_image')
  final String? discountImage;

  @JsonKey(name: 'isDiscountTextEnabled')
  final bool? isDiscountTextEnabled;

  @JsonKey(name: 'isImageEnabled')
  final bool? isImageEnabled;

  @JsonKey(name: 'discountDescription')
  final String? discountDescription;

  DiscountData({
    required this.discountVal,
    this.discountName,
    this.createdOn,
    this.updatedOn,
    this.id,
    this.discountImage,
    this.isDiscountTextEnabled,
    this.isImageEnabled,
    this.discountDescription,
  });

  factory DiscountData.fromJson(Map<String, dynamic> json) =>
      _$DiscountDataFromJson(json);

  Map<String, dynamic> toJson() => _$DiscountDataToJson(this);
}
