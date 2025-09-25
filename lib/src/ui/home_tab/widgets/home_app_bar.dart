import 'package:Artisan/src/constants/colors.dart';
import 'package:Artisan/src/logic/repositories/auth_repository.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../routing/router.dart';

class HomeAppBar extends ConsumerStatefulWidget {
  const HomeAppBar({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends ConsumerState<HomeAppBar> {
  @override
  Widget build(BuildContext context) {
    final wishlist =
        ref.watch(authRepositoryProvider.select((value) => value.wishlist));
    final cartData =
        ref.watch(authRepositoryProvider.select((value) => value.cartData));
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {},
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 21,
            child: SvgPicture.asset(
              'assets/images/white.svg',
              height: 30,
              color: Colors.red,
            ),
          ),
        ),
        SizedBox(
          height: 30,
          child: Row(
            children: [
              Image.asset(
                'assets/images/ic_notification.png',
                height: 26,
              ),
              const SizedBox(
                width: 13,
              ),
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
        )
      ],
    );
  }
}
