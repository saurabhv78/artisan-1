// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:Artisan/src/models/api_response.dart';
import 'package:Artisan/src/models/product_data/product_data.dart';
import 'package:Artisan/src/models/requests/get_list_data_request.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../logic/services/api_services/api_service.dart';
import '../../models/category_data/category_data.dart';
part 'category_tab_page_model.freezed.dart';

final categoryTabPageModelProvider = StateNotifierProvider.autoDispose<
    CategoryTabPageModel, CategoryTabPageState>(
  (ref) => CategoryTabPageModel(
    ref: ref,
    apiService: ref.read(apiServiceProvider),
  ),
);

class CategoryTabPageModel extends StateNotifier<CategoryTabPageState> {
  final ApiService apiService;
  final StateNotifierProviderRef ref;

  CategoryTabPageModel({
    required this.apiService,
    required this.ref,
  }) : super(const CategoryTabPageState());
  Future<ApiResponse<Map<int, List<CategoryData>>>> getCategoryData(
    int page,
  ) async =>
      apiService.getAllCategory(
          getListDataRequest: GetListDataRequest(
        page: page,
        limit: 5,
      ));
  Future<ApiResponse<Map<int, List<ProductData>>>> getProductData(
    int page,
  ) async =>
      apiService.getAllProduct(
          getListDataRequest: GetListDataRequest(
        page: page,
        limit: 5,
      ));
  isRefreshing(bool refresh) => state = state.copyWith(isRefreshing: refresh);
  refreshCount() =>
      state = state.copyWith(refreshCounter: state.refreshCounter + 1);
}

@freezed
class CategoryTabPageState with _$CategoryTabPageState {
  const factory CategoryTabPageState({
    @Default(false) bool isRefreshing,
    @Default(0) int refreshCounter,
    @Default('') String errorMessage,
  }) = _CategoryTabPageState;
}
