// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:Artisan/src/logic/repositories/auth_repository.dart';
import 'package:Artisan/src/models/api_response.dart';
import 'package:Artisan/src/models/wishlist_product_data/wishlist_product_data.dart';
import 'package:Artisan/src/utils/network_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../logic/services/api_services/api_service.dart';
import '../../logic/services/preference_services.dart';

part 'wishlist_page_model.freezed.dart';

final wishlistPageModelProvider =
    StateNotifierProvider.autoDispose<WishlistPageModel, WishlistPageState>(
  (ref) => WishlistPageModel(
    ref: ref,
    apiService: ref.read(apiServiceProvider),
  ),
);

class WishlistPageModel extends StateNotifier<WishlistPageState> {
  final ApiService apiService;
  final StateNotifierProviderRef ref;

  WishlistPageModel({
    required this.apiService,
    required this.ref,
  }) : super(const WishlistPageState()) {
    getWishlistData();
  }

  removeProduct(String prodId) {
    final ind = state.wishlist.indexWhere((element) => element.id == prodId);
    List<WishlistProductData> data = state.wishlist.toList();

    if (ind != -1) {
      data.removeAt(ind);
    }
    state = state.copyWith(wishlist: data);
  }

  getWishlistData() async {
    try {
      state = state.copyWith(
        status: WishlistPageStatus.loading,
        errMessage: "",
      );
      if (!await hasInternetAccess()) {
        if (mounted) {
          state = state.copyWith(
            wishlist: [],
            status: WishlistPageStatus.error,
            errMessage: "No Internet Connection!",
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
      final res = await ref.read(apiServiceProvider).getAllFav(token: token);

      if (res.status != ApiStatus.success) {
        if (mounted) {
          state = state.copyWith(
            status: WishlistPageStatus.error,
            wishlist: [],
            errMessage: res.errorMessage ?? 'Something Went Wrong!',
          );
        }
        return;
      }
      if (mounted) {
        state = state.copyWith(
          status: WishlistPageStatus.loaded,
          errMessage: '',
          wishlist: res.data!,
        );
        ref
            .read(authRepositoryProvider.notifier)
            .addWishlist(res.data?.map((e) => e.id).toList() ?? []);
      }
    } catch (e) {
      if (mounted) {
        state = state.copyWith(
          status: WishlistPageStatus.error,
          wishlist: [],
          errMessage: e.toString(),
        );
      }
    }
  }
}

@freezed
class WishlistPageState with _$WishlistPageState {
  const factory WishlistPageState({
    @Default([]) List<WishlistProductData> wishlist,
    @Default('') String errMessage,
    @Default(WishlistPageStatus.initial) WishlistPageStatus status,
  }) = _WishlistPageState;
}

enum WishlistPageStatus {
  initial,
  loading,
  loaded,
  error,
}
