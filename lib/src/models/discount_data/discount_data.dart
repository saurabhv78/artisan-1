import 'package:json_annotation/json_annotation.dart';

part 'discount_data.g.dart';

@JsonSerializable()
class DiscountData {
  @JsonKey(name: 'discount_val')
  final int discountVal;
  final int status;
  @JsonKey(name: 'created_on')
  final int createdOn;
  @JsonKey(name: 'updated_on')
  final int updatedOn;
  @JsonKey(name: '_id')
  final String id;
  @JsonKey(name: 'discount_image')
  final String discountImage;

  DiscountData({
    required this.discountVal,
    required this.status,
    required this.createdOn,
    required this.updatedOn,
    required this.id,
    required this.discountImage,
  });

  factory DiscountData.fromJson(Map<String, dynamic> json) {
    return _$DiscountDataFromJson(json);
  }

  Map<String, dynamic> toJson() => _$DiscountDataToJson(this);
}
