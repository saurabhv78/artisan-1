// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../logic/services/api_services/api_service.dart';
import '../../models/api_response.dart';
import '../../models/product_data/product_data.dart';
import '../../models/requests/get_list_data_request.dart';
import '../../utils/network_utils.dart';
part 'artist_page_model.freezed.dart';

final artistPageModelProvider =
    StateNotifierProvider.autoDispose<ArtistPageModel, ArtistPageState>(
  (ref) => ArtistPageModel(
    ref: ref,
    apiService: ref.read(apiServiceProvider),
  ),
);

class ArtistPageModel extends StateNotifier<ArtistPageState> {
  final ApiService apiService;
  final StateNotifierProviderRef ref;

  ArtistPageModel({
    required this.apiService,
    required this.ref,
  }) : super(const ArtistPageState());
  getPopularProducts(String artistId) async {
    try {
      state = state.copyWith(
        status: ArtistPageStatus.loading,
        errorMessage: "",
      );
      // await Future.delayed(const Duration(milliseconds: 600));
      if (!await hasInternetAccess()) {
        if (mounted) {
          state = state.copyWith(
            popularProducts: null,
            status: ArtistPageStatus.error,
            errorMessage: "No Internet Connection!",
          );
        }
        return;
      }
      final res = await apiService.getAllProduct(
          getListDataRequest: GetListDataRequest(
        page: 1,
        limit: 4,
        artistId: artistId,
      ));

      // print()
      if (res.status != ApiStatus.success) {
        if (mounted) {
          state = state.copyWith(
            status: ArtistPageStatus.error,
            errorMessage: res.errorMessage ?? 'Something Went Wrong!',
          );
        }
        return;
      }

      if (mounted) {
        state = state.copyWith(
          status: ArtistPageStatus.loaded,
          errorMessage: '',
          popularProducts: res.data!.values.first,
        );
      }
    } catch (e) {
      if (mounted) {
        state = state.copyWith(
          status: ArtistPageStatus.error,
          popularProducts: null,
          errorMessage: e.toString(),
        );
      }
    }
  }
}

@freezed
class ArtistPageState with _$ArtistPageState {
  const factory ArtistPageState({
    @Default(null) List<ProductData>? popularProducts,
    @Default('') String errorMessage,
    @Default(ArtistPageStatus.initial) ArtistPageStatus status,
  }) = _ArtistPageState;
}

enum ArtistPageStatus {
  initial,
  loading,
  loaded,
  error,
}
