import 'package:Artisan/src/logic/repositories/auth_repository.dart';
import 'package:Artisan/src/routing/router.dart';
import 'package:Artisan/src/ui/auth/widgets/back_btn.dart';
import 'package:Artisan/src/ui/product_list/widgets/product_paged_list.dart';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

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
    final isTablet = MediaQuery.of(context).size.width >= 600;

    final double titleFont = isTablet ? 24 : 18;
    final double iconSize = isTablet ? 32 : 26;
    final double iconWidth = isTablet ? 36 : 30;
    final double badgeSize = isTablet ? 20 : 16;
    final double badgeFont = isTablet ? 12 : 10;
    final double spacing = isTablet ? 20 : 13;

    final String title = widget.artStyleId != null
        ? "Trending Art Styles"
        : widget.categoryName != null
            ? "Categories"
            : "Discounted Products";

    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        BackBtn(
          onTap: () => context.maybePop(),
          iconColor: Colors.black,
        ),
        Center(
          child: Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: titleFont,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
              letterSpacing: 0.3,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // ❤️ Wishlist
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => context.pushRoute(const WishlistRoute()),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Image.asset(
                    'assets/images/ic_heart.png',
                    height: iconSize,
                    width: iconWidth,
                  ),
                  if (wishlist.isNotEmpty)
                    Positioned(
                      right: -2,
                      top: -4,
                      child: Container(
                        height: badgeSize,
                        width: badgeSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: primaryColor,
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                        child: Center(
                          child: Text(
                            wishlist.length > 99
                                ? "99"
                                : wishlist.length.toString(),
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: badgeFont,
                              fontWeight: FontWeight.w700,
                              height: 1.1,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(width: spacing),
            // 🛒 Cart
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => context.pushRoute(const CartRoute()),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Image.asset(
                    'assets/images/ic_cart.png',
                    height: iconSize,
                    width: iconWidth,
                  ),
                  if (cartData.isNotEmpty)
                    Positioned(
                      right: -2,
                      top: -4,
                      child: Container(
                        height: badgeSize,
                        width: badgeSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: primaryColor,
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                        child: Center(
                          child: Text(
                            cartData.length > 99
                                ? "99"
                                : cartData.length.toString(),
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: badgeFont,
                              fontWeight: FontWeight.w700,
                              height: 1.1,
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
      Builder(builder: (context) {
        final isTablet = MediaQuery.of(context).size.width >= 600;
        return Text(
          "Shop in \"${widget.categoryName}\"",
          style: GoogleFonts.outfit(
            fontSize: isTablet ? 24 : 18,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
            letterSpacing: 0.3,
          ),
        );
      }),
    ];
  }
}
