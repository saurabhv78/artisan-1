import 'package:Artisan/src/logic/repositories/auth_repository.dart';
import 'package:Artisan/src/routing/router.dart';
import 'package:Artisan/src/ui/auth/widgets/back_btn.dart';
import 'package:Artisan/src/ui/product_list/widgets/product_paged_list.dart';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/colors.dart';

import '../../widgets/custom_scaffold.dart';

@RoutePage()
class ProductListPage extends ConsumerStatefulWidget {
  final String? categoryId;
  final String? categoryName;
  final String? discountId;
  final String? artStyleId;
  const ProductListPage({
    super.key,
    this.categoryName,
    this.categoryId,
    this.discountId,
    this.artStyleId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProductListPageState();
}

class _ProductListPageState extends ConsumerState<ProductListPage> {
  int refreshCounter = 0;
  @override
  Widget build(BuildContext context) {
    final wishlist =
        ref.watch(authRepositoryProvider.select((value) => value.wishlist));
    final cartData =
        ref.watch(authRepositoryProvider.select((value) => value.cartData));
    return CustomScaffold(
        bgColor: const Color(0xffEFE4FF),
        child: RefreshIndicator(
          displacement: 60,
          edgeOffset: 120,
          onRefresh: () async {
            if (mounted) {
              setState(() {
                refreshCounter++;
              });
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: kToolbarHeight),
                  _headers(context, wishlist, cartData),
                  if (widget.categoryName != null) ..._categoryView,
                  Expanded(
                      child: ProductPagedListSection(
                    categoryId: widget.categoryId,
                    discountId: widget.discountId,
                    artStyleId: widget.artStyleId,
                    key: ValueKey(refreshCounter),
                  )),
                ]),
          ),
        ));
  }

  Stack _headers(
      BuildContext context, List<String> wishlist, List<String> cartData) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        BackBtn(
          onTap: () {
            context.maybePop();
          },
          iconColor: Colors.black,
        ),
        Center(
          child: Text(
            widget.artStyleId != null
                ? "Trending Art Styles"
                : widget.categoryName != null
                    ? "Categories"
                    : "Discounted Products",
            style: GoogleFonts.nunitoSans(
              fontSize: widget.categoryName != null ? 20 : 23,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {
                context.pushRoute(const WishlistRoute());
              },
              child: Stack(
                children: [
                  Image.asset(
                    'assets/images/ic_heart.png',
                    height: 26,
                    width: 30,
                  ),
                  if (wishlist.isNotEmpty)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        height: 16,
                        width: 16,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: primaryColor,
                        ),
                        child: Center(
                          child: Text(
                            wishlist.length > 99
                                ? "99"
                                : wishlist.length.toString(),
                            style: GoogleFonts.nunitoSans(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(
              width: 13,
            ),
            GestureDetector(
              onTap: () {
                context.pushRoute(const CartRoute());
              },
              child: Stack(
                children: [
                  Image.asset(
                    'assets/images/ic_cart.png',
                    height: 26,
                    width: 30,
                  ),
                  if (cartData.isNotEmpty)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        height: 16,
                        width: 16,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: primaryColor,
                        ),
                        child: Center(
                          child: Text(
                            cartData.length > 99
                                ? "99"
                                : cartData.length.toString(),
                            style: GoogleFonts.nunitoSans(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  List<Widget> get _categoryView {
    return [
      const SizedBox(height: 20),
      Text(
        "Shop in “${widget.categoryName}”",
        style: GoogleFonts.nunitoSans(
          fontSize: 20,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
      ),
    ];
  }
}
