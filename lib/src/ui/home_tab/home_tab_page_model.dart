// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:Artisan/src/models/api_response.dart';
import 'package:Artisan/src/models/discount_data/discount_data.dart';
import 'package:Artisan/src/models/product_data/product_data.dart';
import 'package:Artisan/src/models/requests/get_list_data_request.dart';
import 'package:Artisan/src/utils/network_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../logic/services/api_services/api_service.dart';
import '../../models/artist_data/artist_data.dart';
import '../../models/category_data/category_data.dart';
import '../../models/product_data/featured_product.dart';
part 'home_tab_page_model.freezed.dart';

final homeTabPageModelProvider =
    StateNotifierProvider.autoDispose<HomeTabPageModel, HomeTabPageState>(
  (ref) => HomeTabPageModel(
    ref: ref,
    apiService: ref.read(apiServiceProvider),
  ),
);

class HomeTabPageModel extends StateNotifier<HomeTabPageState> {
  final ApiService apiService;
  final StateNotifierProviderRef ref;

  HomeTabPageModel({
    required this.apiService,
    required this.ref,
  }) : super(const HomeTabPageState()) {
    Future.delayed(Duration.zero, () async {
      await init();
    });
  }

  init() async {
    state = state.copyWith(
      errorMessage: '',
      status: HomePageStatus.loading,
    );

    try {
      if (!await hasInternetAccess()) {
        state = state.copyWith(
          status: HomePageStatus.error,
          discountData: null,
          categoryData: null,
          featuredProducts: null,
          errorMessage: "No Internet Connection!!!",
        );
        return;
      }
      final res = await apiService.getAllCategory(
          getListDataRequest: const GetListDataRequest(
        page: 1,
        limit: 5,
      ));
      if (res.status != ApiStatus.success) {
        state = state.copyWith(
          status: HomePageStatus.error,
          categoryData: null,
          discountData: null,
          featuredProducts: null,
          errorMessage: res.errorMessage ?? "Something Went Wrong!!!",
        );
        return;
      }
      if (mounted) {
        state = state.copyWith(
          errorMessage: "",
          categoryData: res.data!.values.first,
        );

        await getFeaturedProduct();
      }
      return;
    } catch (e) {
      state = state.copyWith(
        status: HomePageStatus.error,
        discountData: null,
        categoryData: null,
        featuredProducts: null,
        errorMessage: e.toString(),
      );
    } finally {
      if (mounted) {
        state = state.copyWith(
          status: HomePageStatus.loaded,
        );
      }
    }
  }

  getFeaturedProduct() async {
    try {
      if (!await hasInternetAccess()) {
        state = state.copyWith(
          status: HomePageStatus.error,
          discountData: null,
          categoryData: null,
          trendingArtists: null,
          featuredProducts: null,
          errorMessage: "No Internet Connection!!!",
        );
        return;
      }
      final res = await apiService.getAllFeatured(
          getListDataRequest: const GetListDataRequest(
        page: 1,
        limit: 3,
      ));
      if (res.status != ApiStatus.success) {
        state = state.copyWith(
          status: HomePageStatus.error,
          discountData: null,
          categoryData: null,
          trendingArtists: null,
          featuredProducts: null,
          errorMessage: res.errorMessage ?? "Something Went Wrong!!!",
        );
        return;
      }
      if (mounted) {
        state = state.copyWith(
          errorMessage: "",
          featuredProducts: res.data ?? [],
        );
        /// TODO : do it later
        // await getTrendingArtist();
      }
      return;
    } catch (e) {
      state = state.copyWith(
        status: HomePageStatus.error,
        discountData: null,
        categoryData: null,
        trendingArtists: null,
        featuredProducts: null,
        errorMessage: e.toString(),
      );
    }
  }

  getTrendingArtist() async {
    // try {print

    if (!await hasInternetAccess()) {
      state = state.copyWith(
        status: HomePageStatus.error,
        discountData: null,
        categoryData: null,
        trendingArtists: null,
        featuredProducts: null,
        errorMessage: "No Internet Connection!!!",
      );
      return;
    }
    final res = await apiService.getAllArtists(
        getListDataRequest: const GetListDataRequest(
      page: 1,
      limit: 2,
    ));

    if (res.status != ApiStatus.success) {
      state = state.copyWith(
        status: HomePageStatus.error,
        discountData: null,
        categoryData: null,
        trendingArtists: null,
        featuredProducts: null,
        errorMessage: res.errorMessage ?? "Something Went Wrong!!!",
      );
      return;
    }

    List<ProductData> trendArtist = [];

    for (ArtistData data in res.data!.values.first) {
      final response = await apiService.getAllProduct(
          getListDataRequest: GetListDataRequest(
        artistId: data.id,
        page: 1,
        limit: 1,
      ));
      if (response.status != ApiStatus.success) {
        state = state.copyWith(
          status: HomePageStatus.error,
          discountData: null,
          categoryData: null,
          trendingArtists: null,
          featuredProducts: null,
          errorMessage: res.errorMessage ?? "Something Went Wrong!!!",
        );
        return;
      }
      if (mounted) {
        trendArtist.add(response.data!.values.first.first);
      }
    }
    if (mounted) {
      state = state.copyWith(
        status: HomePageStatus.loaded,
        errorMessage: "",
        trendingArtists: trendArtist,
      );
      await getDiscount();
    }
    return;
    // } catch (e) {
    //   state = state.copyWith(
    //     status: HomePageStatus.error,
    //     discountData: null,
    //     categoryData: null,
    //     trendingArtists: null,
    //     featuredProducts: null,
    //     errorMessage: e.toString(),
    //   );
    // }
  }

  getDiscount() async {
    try {
      if (!await hasInternetAccess()) {
        state = state.copyWith(
          status: HomePageStatus.error,
          discountData: null,
          categoryData: null,
          trendingArtists: null,
          featuredProducts: null,
          errorMessage: "No Internet Connection!!!",
        );
        return;
      }
      final res = await apiService.getAllDiscount(
          getListDataRequest: const GetListDataRequest(
        page: 1,
        limit: 5,
      ));
      if (res.status != ApiStatus.success) {
        state = state.copyWith(
          status: HomePageStatus.error,
          discountData: null,
          categoryData: null,
          trendingArtists: null,
          featuredProducts: null,
          errorMessage: res.errorMessage ?? "Something Went Wrong!!!",
        );
        return;
      }
      if (mounted) {
        state = state.copyWith(
          status: HomePageStatus.loaded,
          errorMessage: "",
          discountData: res.data!.values.first,
        );
      }
      return;
    } catch (e) {
      state = state.copyWith(
        status: HomePageStatus.error,
        discountData: null,
        categoryData: null,
        trendingArtists: null,
        featuredProducts: null,
        errorMessage: e.toString(),
      );
    }
  }
}

@freezed
class HomeTabPageState with _$HomeTabPageState {
  const factory HomeTabPageState({
    @Default(null) List<CategoryData>? categoryData,
    @Default(null) List<DiscountData>? discountData,
    @Default(null) List<FeaturedProduct>? featuredProducts,
    @Default(null) List<ProductData>? trendingArtists,
    @Default('') String errorMessage,
    @Default(HomePageStatus.initial) HomePageStatus status,
  }) = _HomeTabPageState;
}

enum HomePageStatus {
  initial,
  loading,
  loaded,
  error,
}
