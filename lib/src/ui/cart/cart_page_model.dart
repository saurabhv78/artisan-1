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
        state.cartData.items.indexWhere((element) => element.id == prodId);
    List<CartItem> data = state.cartData.items.toList();

    if (ind != -1) {
      data.removeAt(ind);
    }
    state = state.copyWith(
      cartData: state.cartData.copyWith(items: data),
    );
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
            cartData: CartData(),
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
            cartData: CartData(),
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
            .addCartData(res.data?.items.map((e) => e.id).toList() ?? []);
      }
    } catch (e) {
      if (mounted) {
        state = state.copyWith(
          status: CartPageStatus.error,
          cartData: CartData(),
          errorMessage: e.toString(),
        );
      }
    }
  }

  Future<Map<bool, String>> removeFromCart(
      String prodId, num discountVal) async {
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
    @Default(CartData()) CartData cartData,
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
