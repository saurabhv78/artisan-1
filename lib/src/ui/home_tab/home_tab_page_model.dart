// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:ffi';

import 'package:Artisan/src/models/api_response.dart';
import 'package:Artisan/src/models/artstyle_data/art_style_data.dart';
import 'package:Artisan/src/models/discount_data/discount_data.dart';
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

  init({bool loading = true}) async {
    state = state.copyWith(
      errorMessage: '',
      status: loading ? HomePageStatus.loading : state.status,
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
      final catRes = await apiService.getAllCategory(
          getListDataRequest: const GetListDataRequest(page: 1, limit: 5));
      final discountRes = await apiService.getAllDiscount(
          getListDataRequest: const GetListDataRequest(page: 1, limit: 5));
      final featuredRes = await apiService.getAllFeatured(
          getListDataRequest: const GetListDataRequest(page: 1, limit: 3));
      final trendingArtistRes = await apiService.getTrendingArtists(
        getListDataRequest: const GetListDataRequest(page: 1, limit: 2),
      );
      final trendingArtStyleRes = await apiService.getTrendingArtstyle(
        getListDataRequest: const GetListDataRequest(page: 1, limit: 2),
      );
      if ([
        catRes.status,
        discountRes.status,
        featuredRes.status,
        trendingArtistRes.status,
        trendingArtStyleRes.status,
      ].any((e) => e != ApiStatus.success)) {
        state = state.copyWith(
          status: HomePageStatus.error,
          categoryData: null,
          discountData: null,
          featuredProducts: null,
          trendingArtists: null,
          trendingArtStyles: null,
          errorMessage: "Something Went Wrong!!!",
        );
        return;
      }

      state = state.copyWith(
        status: HomePageStatus.loaded,
        categoryData: catRes.data?.values.first,
        trendingArtists: trendingArtistRes.data?.values.first,
        // trendingArtStyles: trendingArtStyleRes.data?.values.first,
        featuredProducts: featuredRes.data ?? [],
        discountData: discountRes.data?.values.first,
        errorMessage: catRes.errorMessage ?? "Something Went Wrong!!!",
      );
    } catch (e) {
      state = state.copyWith(
        status: HomePageStatus.error,
        discountData: null,
        categoryData: null,
        featuredProducts: null,
        errorMessage: e.toString(),
      );
    }
  }
/* 
  Future<void> getAllCategory() async {}

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
        await getTrendingArtist();
        await getTrendingArtStyle();
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
    if (!await hasInternetAccess()) {
      state = state.copyWith(
        status: HomePageStatus.error,
        trendingArtists: null,
        errorMessage: "No Internet Connection!!!",
      );
      return;
    }

    final res = await apiService.getTrendingArtists(
      getListDataRequest: const GetListDataRequest(page: 1, limit: 2),
    );

    if (res.status != ApiStatus.success || res.data == null) {
      state = state.copyWith(
        status: HomePageStatus.error,
        trendingArtists: null,
        errorMessage: res.errorMessage ?? "Something Went Wrong!!!",
      );
      return;
    }

    final List<ArtistData> artists = List<ArtistData>.from(
      res.data!.values.first,
    );

    // List<TrendingArtistsResponse> trendingProducts = [];

    // for (final artist in artists) {
    //   final productRes = await apiService.getAllProduct(
    //     getListDataRequest: GetListDataRequest(
    //       artistId: artist.id,
    //       page: 1,
    //       limit: 1,
    //     ),
    //   );

    //   if (productRes.status == ApiStatus.success &&
    //       productRes.data != null &&
    //       productRes.data!.values.first.isNotEmpty) {
    //     // trendingProducts.add(productRes.data!.values.first.first);
    //   }
    // }

    if (mounted) {
      state = state.copyWith(
        status: HomePageStatus.loaded,
        trendingArtists: artists,
        errorMessage: "",
      );
    }
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

  getTrendingArtStyle() async {
    if (!await hasInternetAccess()) {
      state = state.copyWith(
        status: HomePageStatus.error,
        trendingArtists: null,
        errorMessage: "No Internet Connection!!!",
      );
      return;
    }

    final res = await apiService.getTrendingArtstyle(
      getListDataRequest: const GetListDataRequest(page: 1, limit: 2),
    );

    if (res.status != ApiStatus.success || res.data == null) {
      state = state.copyWith(
        status: HomePageStatus.error,
        trendingArtStyles: null,
        errorMessage: res.errorMessage ?? "Something Went Wrong!!!",
      );
      return;
    }

    /// TODO : do it later
    /* final List<ArtStyle> artstyle = List<ArtStyle>.from(
      res.data!.values.first,
    );

    if (mounted) {
      state = state.copyWith(
        status: HomePageStatus.loaded,
        trendingArtStyles: artstyle,
        errorMessage: "",
      );
    } */
  }
 */
}

@freezed
class HomeTabPageState with _$HomeTabPageState {
  const factory HomeTabPageState({
    @Default(null) List<CategoryData>? categoryData,
    @Default(null) List<DiscountData>? discountData,
    @Default(null) List<FeaturedProduct>? featuredProducts,
    @Default(null) List<ArtistData>? trendingArtists,
    @Default(null) List<ArtStyle>? trendingArtStyles,
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
