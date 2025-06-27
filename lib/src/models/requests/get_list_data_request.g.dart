// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_list_data_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetListDataRequest _$GetListDataRequestFromJson(Map<String, dynamic> json) =>
    GetListDataRequest(
      page: (json['page'] as num?)?.toInt(),
      limit: (json['limit'] as num?)?.toInt(),
      artistId: json['seller'] as String?,
      categoryId: json['category'] as String?,
      productId: json['id'] as String?,
      discountId: json['discount'] as String?,
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
  writeNotNull('id', instance.productId);
  writeNotNull('category', instance.categoryId);
  writeNotNull('seller', instance.artistId);
  writeNotNull('discount', instance.discountId);
  writeNotNull('search_by', instance.searchBy);
  writeNotNull('product_id', instance.updateFavProdId);
  return val;
}
