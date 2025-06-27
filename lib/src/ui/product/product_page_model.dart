// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:Artisan/src/logic/services/preference_services.dart';
import 'package:Artisan/src/models/api_response.dart';
import 'package:Artisan/src/utils/network_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../logic/services/api_services/api_service.dart';
import '../../models/product_data/product_data.dart';
import '../../models/requests/get_list_data_request.dart';

part 'product_page_model.freezed.dart';

final productPageModelProvider =
    StateNotifierProvider.autoDispose<ProductPageModel, ProductPageState>(
  (ref) => ProductPageModel(
    ref: ref,
    apiService: ref.read(apiServiceProvider),
  ),
);

class ProductPageModel extends StateNotifier<ProductPageState> {
  final ApiService apiService;
  final StateNotifierProviderRef ref;

  ProductPageModel({
    required this.apiService,
    required this.ref,
  }) : super(const ProductPageState());
  getProductData(String prodId) async {
    if (!state.id.contains(prodId)) {
      state = state.copyWith(id: state.id.toList()..add(prodId));
    }
    try {
      state = state.copyWith(
        status: ProductPageStatus.loading,
        errMessage: "",
      );
      await Future.delayed(const Duration(milliseconds: 600));
      if (!await hasInternetAccess()) {
        if (mounted) {
          state = errorState('No Internet Connection!');
        }
        return;
      }
      final res = await apiService.getProductDetail(
          getListDataRequest: GetListDataRequest(
        productId: prodId,
      ));

      if (res.status != ApiStatus.success) {
        if (mounted) state = errorState();
        return;
      }

      if (mounted) {
        state = state.copyWith(
          // status: ProductPageStatus.loaded,
          errMessage: '',
          productData: res.data!,
          // moreByArtist: res.data,
        );
        await getMoreByArtist(res.data!.artistData?.id ?? '');
      }
      return;
    } catch (e) {
      if (mounted) {
        state = state.copyWith(
          status: ProductPageStatus.error,
          productData: null,
          moreByArtist: null,
          errMessage: e.toString(),
        );
      }
    }
  }

  ProductPageState errorState([String? s]) {
    return state.copyWith(
      productData: null,
      moreByArtist: null,
      status: ProductPageStatus.error,
      errMessage: s ?? "Something Went Wrong!",
    );
  }

  addToCart(String prodId, int discountVal, bool isAdded) async {
    if (!await hasInternetAccess()) {
      return {false: "No Internet Connection"};
    }

    try {
      final token = ref
          .read(sharedPreferencesProvider)
          .getString(PreferenceService.authToken);

      if (token == null || token.trim().isEmpty) {
        return {false: "Auth Error!. Login again!"};
      }
      final res = await apiService.updateCartData(
          token: token, productId: prodId, discount: discountVal, add: isAdded);
      if (res.status != ApiStatus.success) {
        return {false: res.errorMessage ?? "Something Went Wrong"};
      }

      return {true: res.data!.isEmpty ? "Added to cart" : res.data};
    } catch (e) {
      return {false: e.toString()};
    }
  }

  removeId(String prodId) {
    state = state.copyWith(
        id: state.id.toList()..removeWhere((element) => element == prodId));
    if (mounted) {
      if (state.id.isNotEmpty) {
        getProductData(state.id.last);
      }
    }
  }

  getMoreByArtist(String artistId) async {
    try {
      state = state.copyWith(
        status: ProductPageStatus.loading,
        errMessage: "",
      );
      // await Future.delayed(const Duration(milliseconds: 600));
      if (!await hasInternetAccess()) {
        if (mounted) {
          state = state.copyWith(
            productData: null,
            moreByArtist: null,
            status: ProductPageStatus.error,
            errMessage: "No Internet Connection!",
          );
        }
        return;
      }
      final res = await apiService.getAllProduct(
          getListDataRequest: GetListDataRequest(
        page: 1,
        limit: 5,
        artistId: artistId,
      ));

      // print()
      if (res.status != ApiStatus.success) {
        if (mounted) {
          state = state.copyWith(
            status: ProductPageStatus.error,
            productData: null,
            moreByArtist: null,
            errMessage: res.errorMessage ?? 'Something Went Wrong!',
          );
        }
        return;
      }

      if (mounted) {
        state = state.copyWith(
          status: ProductPageStatus.loaded,
          errMessage: '',
          moreByArtist: res.data!.values.first,
        );
      }
    } catch (e) {
      if (mounted) {
        state = state.copyWith(
          status: ProductPageStatus.error,
          productData: null,
          moreByArtist: null,
          errMessage: e.toString(),
        );
      }
    }
  }
}

@freezed
class ProductPageState with _$ProductPageState {
  const factory ProductPageState({
    @Default(null) List<ProductData>? moreByArtist,
    @Default(null) ProductData? productData,
    @Default([]) List<String> id,
    @Default('') String errMessage,
    @Default(ProductPageStatus.initial) ProductPageStatus status,
  }) = _ProductPageState;
}

enum ProductPageStatus {
  initial,
  loading,
  loaded,
  error,
}
