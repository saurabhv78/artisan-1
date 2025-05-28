// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

part 'category_data.g.dart';

@JsonSerializable()
class CategoryData {
  @JsonKey(name: 'cat_name')
  final String catName;
  final int status;
  @JsonKey(name: 'created_on')
  final int createdOn;
  @JsonKey(name: 'updated_on')
  int? updatedOn;
  @JsonKey(name: '_id')
  final String id;
  @JsonKey(name: 'cat_image')
  final String catImage;

  CategoryData({
    required this.catName,
    required this.status,
    required this.createdOn,
    this.updatedOn,
    required this.id,
    required this.catImage,
  });

  factory CategoryData.fromJson(Map<String, dynamic> json) {
    return _$CategoryDataFromJson(json);
  }

  Map<String, dynamic> toJson() => _$CategoryDataToJson(this);
}
