// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../logic/services/api_services/api_service.dart';
import '../../models/api_response.dart';
import '../../models/product_data/product_data.dart';
import '../../models/requests/get_list_data_request.dart';

part 'search_page_model.freezed.dart';

final searchPageModelProvider =
    StateNotifierProvider.autoDispose<SearchPageModel, SearchPageState>(
  (ref) => SearchPageModel(
    ref: ref,
    apiService: ref.read(apiServiceProvider),
  ),
);

class SearchPageModel extends StateNotifier<SearchPageState> {
  final ApiService apiService;
  final StateNotifierProviderRef ref;

  SearchPageModel({
    required this.apiService,
    required this.ref,
  }) : super(const SearchPageState());
  Future<ApiResponse<Map<int, List<ProductData>>>> getProductData(
    int page,
  ) async =>
      ref.read(apiServiceProvider).getAllProduct(
              getListDataRequest: GetListDataRequest(
            page: page,
            limit: 5,
            searchBy: state.searchText,
          ));
  setText(String text) => state = state.copyWith(searchText: text);
}

@freezed
class SearchPageState with _$SearchPageState {
  const factory SearchPageState({
    @Default('') String searchText,
  }) = _SearchPageState;
}
