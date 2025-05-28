import 'package:Artisan/src/ui/trending_artist/widgets/trending_artist_list.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/colors.dart';

import '../../logic/repositories/auth_repository.dart';
import '../../routing/router.dart';
import '../../widgets/custom_scaffold.dart';
import '../auth/widgets/back_btn.dart';

@RoutePage()
class TrendingArtistPage extends ConsumerStatefulWidget {
  const TrendingArtistPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TrendingArtistPageState();
}

class _TrendingArtistPageState extends ConsumerState<TrendingArtistPage> {
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
                          "Trending Artists",
                          style: GoogleFonts.nunitoSans(
                            fontSize: 20,
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
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Trending Artists this week",
                    style: GoogleFonts.nunitoSans(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Expanded(
                      child: TrendingArtistPagedListSection(
                    key: ValueKey(refreshCounter),
                  )),
                ]),
          ),
        ));
  }
}
