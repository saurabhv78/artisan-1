import 'package:Artisan/src/ui/wishlist/widgets/wishlist_list.dart';
import 'package:Artisan/src/ui/wishlist/wishlist_page_model.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/colors.dart';
import '../../logic/repositories/auth_repository.dart';
import '../../routing/router.dart';
import '../../widgets/custom_scaffold.dart';
import '../../widgets/try_again_widget.dart';
import '../auth/widgets/back_btn.dart';

@RoutePage()
class WishlistPage extends ConsumerStatefulWidget {
  const WishlistPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WishlistPageState();
}

class _WishlistPageState extends ConsumerState<WishlistPage> {
  @override
  Widget build(BuildContext context) {
    ref.listen(wishlistPageModelProvider, (previous, next) {});
    final data =
        ref.watch(wishlistPageModelProvider.select((value) => value.wishlist));
    final status =
        ref.watch(wishlistPageModelProvider.select((value) => value.status));
    final cartData =
        ref.watch(authRepositoryProvider.select((value) => value.cartData));
    return CustomScaffold(
        topPadding: 35,
        bgColor: const Color(0xffEFE4FF),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            const SizedBox(
              height: 15,
            ),
            Stack(
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
                    "Wishlist",
                    style: GoogleFonts.nunitoSans(
                      fontSize: 24,
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
            ),
            if (status == WishlistPageStatus.loaded && data.isNotEmpty) ...[
              Expanded(
                child: WishListSection(
                  data: data,
                ),
              ),
            ] else
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 300),
                child: const Center(child: Text("No Favourite Found")),
              )
            // TryAgainWidget(
            //   onTap: () {
            //     ref
            //         .read(wishlistPageModelProvider.notifier)
            //         .getWishlistData();
            //   },
            //   isProcessing: status == WishlistPageStatus.initial ||
            //       status == WishlistPageStatus.loading,
            //   errMessage: ref.watch(
            //     wishlistPageModelProvider.select(
            //       (value) => value.errMessage.trim().isEmpty
            //           ? data.isEmpty
            //               ? "No Favourite Found"
            //               : "Something Went Wrong!!!"
            //           : value.errMessage.trim(),
            //     ),
            //   ),
            // )
          ]),
        ));
  }
}
