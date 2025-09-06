import 'package:Artisan/src/constants/colors.dart';
import 'package:Artisan/src/logic/repositories/auth_repository.dart';
import 'package:Artisan/src/logic/services/api_services/api_service.dart';
import 'package:Artisan/src/models/artstyle_data/art_style_data.dart';
import 'package:Artisan/src/utils/toast_utils.dart';

import 'package:Artisan/src/widgets/artisan_paged_list.dart';
import 'package:Artisan/src/widgets/components/images.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../models/api_response.dart';

import '../../../models/product_data/product_data.dart';
import '../../../models/requests/get_list_data_request.dart';
import '../../../routing/router.dart';

import '../../../widgets/product_card.dart';

class TrendingArtPagedListSection extends ConsumerStatefulWidget {
  const TrendingArtPagedListSection({
    super.key,
  });

  @override
  ConsumerState<TrendingArtPagedListSection> createState() =>
      _TrendingArtListSection();
}

class _TrendingArtListSection
    extends ConsumerState<TrendingArtPagedListSection> {
  static const _pageSize = 5;

  final PagingController<int, ArtStyle> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future<ApiResponse<Map<int, List<ArtStyle>>>> getTrendingArtistData(
    int page,
  ) async =>
      ref.read(apiServiceProvider).getTrendingArtstyle(
          token: ref.read(authRepositoryProvider).authUser?.token ??
              "", // Ensure token is passed correctly
          getListDataRequest: GetListDataRequest(
            page: page,
            limit: 5,
          ));
  Future<void> _fetchPage(int pageKey) async {
    final response = await getTrendingArtistData(pageKey);
    if (response.status != ApiStatus.success) {
      _pagingController.error =
          response.errorMessage ?? 'Something went wrong!';
    } else {
      final list = response.data!.values.first;
      final isLastPage = list.length < _pageSize ||
          (_pagingController.itemList?.length ?? 0) + _pageSize >=
              response.data!.keys.first;
      if (isLastPage) {
        _pagingController.appendLastPage(list);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(list, nextPageKey);
      }
    }
  }

  // _refresh() async {
  //   await Future.delayed(const Duration(seconds: 1));
  //   final response = await getTrendingArtistData(1);

  //   _pagingController.value.itemList?.clear();
  //   if (mounted) {
  //     setState(() {});
  //   }
  //   // _pagingController.refresh();
  //   if (response.status != ApiStatus.success) {
  //     // print(response.errorMessage);
  //     _pagingController.error =
  //         response.errorMessage ?? 'Something went wrong!';
  //     _pagingController.refresh();
  //   } else {
  //     final list = response.data!.values.first;

  //     final isLastPage = list.length < _pageSize;
  //     if (isLastPage) {
  //       _pagingController.appendLastPage(list);
  //     } else {
  //       _pagingController.appendPage(list, 2);
  //     }
  //   }
  //   // ref.read(categoryTabPageModelProvider.notifier).isRefreshing(false);
  //   if (mounted) {
  //     setState(() {});
  //   }
  // }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ref.listen(
    //   categoryTabPageModelProvider,
    //   (previous, next) {
    //     if (previous?.refreshCounter != next.refreshCounter) {
    //       debugPrint('Refreshing...');
    //       _refresh();
    //     }
    //   },
    // );

    return ArtisanPagedList<ArtStyle>(_pagingController,
        padding: const EdgeInsets.only(bottom: 50),
        itemBuilder: (context, data, index) {
      return GestureDetector(
        onTap: () {
          context.navigateTo(ProductListRoute(
              artStyleId: data.id ?? '', categoryName: data.name ?? ''));
          // context.pushRoute(ProductRoute(
          //   id: data.id,
          // ));
        },
        child: Padding(
          padding: EdgeInsets.only(top: 15, right: index % 2 == 0 ? 15 : 0),
          // Convert ArtStyle to ProductData or use a suitable widget
          // Example: If you have a method to convert ArtStyle to ProductData:
          // child: ProductCard(
          //   data: artStyleToProductData(data),
          //   index: index,
          //   key: ValueKey(data),
          // ),
          // Or use a widget that accepts ArtStyle:
          child: YourArtStyleCardWidget(
            artStyle: data,
            index: index,
            key: ValueKey(data),
          ),
        ),
      );
    }
        // noItemsFoundBuilder: (context) => const Text("No Item Found"),
        );
  }
}

class YourArtStyleCardWidget extends ConsumerWidget {
  final ArtStyle artStyle;
  final int index;

  const YourArtStyleCardWidget({
    Key? key,
    required this.artStyle,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      key: ValueKey(index),
      padding: EdgeInsets.only(
          top: 10,
          bottom: 10,
          right: index % 2 == 0 ? 5 : 0,
          left: index % 2 != 0 ? 5 : 0),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: 170,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.shade300.withOpacity(0.5),
                    ),
                    child: NetworkImageWidget(
                      artStyle.file ?? '',
                      height: 170,
                      width: MediaQuery.sizeOf(context).width,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  // crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        artStyle.name ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.nunitoSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.star,
                      color: Color(0xffFCAF23),
                      size: 20,
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    // Text(
                    //   artStyle.,
                    //   style: GoogleFonts.nunitoSans(
                    //     fontSize: 12,
                    //     fontWeight: FontWeight.w400,
                    //     color: subHead,
                    //   ),
                    // ),
                  ],
                ),
                // Text(
                //   "₹${(artStyle.discountData != null ? (artStyle.prodPrice - artStyle.prodPrice * artStyle.discountData!.discountVal / 100) : artStyle.prodPrice).toStringAsFixed(2)}",
                //   style: GoogleFonts.nunitoSans(
                //     fontWeight: FontWeight.w400,
                //     color: bgDark,
                //     fontSize: 14,
                //     letterSpacing: .2,
                //   ),
                // ),
              ],
            ),
          ),
          Positioned(
            right: 10,
            top: 10,
            child: GestureDetector(
              onTap: () async {
                // You may need to refactor this logic if you want to handle state (like isProcessing) and mounted/setState,
                // as ConsumerWidget does not have them. Consider using a state management solution or a StatefulWidget+Consumer.
                // For now, just remove the isProcessing/mounted/setState logic or refactor as needed.
                final res = await ref
                    .read(authRepositoryProvider.notifier)
                    .updateFav(artStyle.id);
                if (res.keys.first != true) {
                  showErrorMessage(res.values.first);
                } else {
                  showSuccessMessage(res.values.first);
                  ref.read(authRepositoryProvider.notifier).getWishlist();
                }
              },
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 13,
                child: Icon(
                  Icons.favorite,
                  color: ref.watch(authRepositoryProvider.select((value) =>
                              value.wishlist.indexWhere(
                                  (element) => element == artStyle.id))) !=
                          -1
                      ? Colors.red
                      : const Color(0xffC5C5C5),
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
