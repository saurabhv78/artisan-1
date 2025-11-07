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
      artStyleId: json['artStyleId'] as String?,
      updateFavProdId: json['productId'] as String?,
    );

Map<String, dynamic> _$GetListDataRequestToJson(GetListDataRequest instance) =>
    <String, dynamic>{
      if (instance.page case final value?) 'page': value,
      if (instance.limit case final value?) 'limit': value,
      if (instance.productId case final value?) 'id': value,
      if (instance.categoryId case final value?) 'category': value,
      if (instance.artistId case final value?) 'seller': value,
      if (instance.discountId case final value?) 'discount': value,
      if (instance.searchBy case final value?) 'search_by': value,
      if (instance.artStyleId case final value?) 'artStyleId': value,
      if (instance.updateFavProdId case final value?) 'productId': value,
    };
