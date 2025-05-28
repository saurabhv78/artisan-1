// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_list_data_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetListDataRequest _$GetListDataRequestFromJson(Map<String, dynamic> json) =>
    GetListDataRequest(
      page: (json['page'] as num?)?.toInt(),
      limit: (json['limit'] as num?)?.toInt(),
      artistId: json['artist_id'] as String?,
      categoryId: json['cat_id'] as String?,
      productId: json['prod_id'] as String?,
      discountId: json['discount_id'] as String?,
      searchBy: json['search_by'] as String?,
      updateFavProdId: json['product_id'] as String?,
    );

Map<String, dynamic> _$GetListDataRequestToJson(GetListDataRequest instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('page', instance.page);
  writeNotNull('limit', instance.limit);
  writeNotNull('prod_id', instance.productId);
  writeNotNull('cat_id', instance.categoryId);
  writeNotNull('artist_id', instance.artistId);
  writeNotNull('discount_id', instance.discountId);
  writeNotNull('search_by', instance.searchBy);
  writeNotNull('product_id', instance.updateFavProdId);
  return val;
}
