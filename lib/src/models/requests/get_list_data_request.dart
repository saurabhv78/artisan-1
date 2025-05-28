import 'package:json_annotation/json_annotation.dart';

part 'get_list_data_request.g.dart';

@JsonSerializable(includeIfNull: false)
class GetListDataRequest {
  final int? page;
  final int? limit;
  @JsonKey(name: "prod_id")
  final String? productId;

  @JsonKey(name: "cat_id")
  final String? categoryId;

  @JsonKey(name: "artist_id")
  final String? artistId;
  @JsonKey(name: "discount_id")
  final String? discountId;
  @JsonKey(name: "search_by")
  final String? searchBy;
  @JsonKey(name: "product_id")
  final String? updateFavProdId;

  const GetListDataRequest({
    this.page,
    this.limit,
    this.artistId,
    this.categoryId,
    this.productId,
    this.discountId,
    this.searchBy,
    this.updateFavProdId,
  });

  factory GetListDataRequest.fromJson(Map<String, dynamic> json) {
    return _$GetListDataRequestFromJson(json);
  }
  Map<String, dynamic> toJson() => _$GetListDataRequestToJson(this);
}
