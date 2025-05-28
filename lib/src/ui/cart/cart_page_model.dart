// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../logic/repositories/auth_repository.dart';
import '../../logic/services/api_services/api_service.dart';
import '../../logic/services/preference_services.dart';
import '../../models/api_response.dart';
import '../../models/cart_data/cart_data.dart';
import '../../utils/network_utils.dart';

part 'cart_page_model.freezed.dart';

final cartPageModelProvider =
    StateNotifierProvider.autoDispose<CartPageModel, CartPageState>(
  (ref) => CartPageModel(
    ref: ref,
    apiService: ref.read(apiServiceProvider),
  ),
);

class CartPageModel extends StateNotifier<CartPageState> {
  final ApiService apiService;
  final StateNotifierProviderRef ref;

  CartPageModel({
    required this.apiService,
    required this.ref,
  }) : super(const CartPageState()) {
    getCartData();
  }
  removeProduct(String prodId) {
    final ind =
        state.cartData.indexWhere((element) => element.prodId.id == prodId);
    List<CartData> data = state.cartData.toList();

    if (ind != -1) {
      data.removeAt(ind);
    }
    state = state.copyWith(cartData: data);
  }

  getCartData() async {
    try {
      state = state.copyWith(
        status: CartPageStatus.loading,
        errorMessage: "",
      );
      if (!await hasInternetAccess()) {
        if (mounted) {
          state = state.copyWith(
            cartData: [],
            status: CartPageStatus.error,
            errorMessage: "No Internet Connection!",
          );
        }
        return;
      }
      final token = ref
          .read(sharedPreferencesProvider)
          .getString(PreferenceService.authToken);
      if (token == null || token.isEmpty) {
        return "Auth Error. Login Again!";
      }
      final res = await ref.read(apiServiceProvider).getAllCart(token: token);

      if (res.status != ApiStatus.success) {
        if (mounted) {
          state = state.copyWith(
            status: CartPageStatus.error,
            cartData: [],
            errorMessage: res.errorMessage ?? 'Something Went Wrong!',
          );
        }
        return;
      }
      if (mounted) {
        state = state.copyWith(
          status: CartPageStatus.loaded,
          errorMessage: '',
          cartData: res.data!,
        );
        ref
            .read(authRepositoryProvider.notifier)
            .addCartData(res.data?.map((e) => e.prodId.id).toList() ?? []);
      }
    } catch (e) {
      if (mounted) {
        state = state.copyWith(
          status: CartPageStatus.error,
          cartData: [],
          errorMessage: e.toString(),
        );
      }
    }
  }

  Future<Map<bool, String>> removeFromCart(
      String prodId, int discountVal) async {
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
          token: token, productId: prodId, discount: discountVal, add: false);
      if (res.status != ApiStatus.success) {
        return {false: res.errorMessage ?? "Something Went Wrong"};
      }
      removeProduct(prodId);
      ref.read(authRepositoryProvider.notifier).getCartData();
      return {
        true: res.data!.isEmpty
            ? "Removed from Cart"
            : res.data ?? "Removed from Cart"
      };
    } catch (e) {
      return {false: e.toString()};
    }
  }
}

@freezed
class CartPageState with _$CartPageState {
  const factory CartPageState({
    @Default([]) List<CartData> cartData,
    @Default('') String errorMessage,
    @Default(CartPageStatus.initial) CartPageStatus status,
  }) = _CartPageState;
}

enum CartPageStatus {
  initial,
  loaded,
  loading,
  error,
}
