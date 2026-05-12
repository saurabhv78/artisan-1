import 'dart:developer';

import 'package:Artisan/src/constants/colors.dart';
import 'package:Artisan/src/logic/repositories/auth_repository.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../routing/router.dart';

class HomeAppBar extends ConsumerStatefulWidget {
  const HomeAppBar({super.key});

  @override
  ConsumerState<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends ConsumerState<HomeAppBar> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final bool isTablet = width >= 600;

    // Responsive Sizes
    double avatarRadius = isTablet ? 28 : 21;
    double iconSize = isTablet ? 34 : 26;
    double badgeSize = isTablet ? 24 : 18;
    double badgeFont = isTablet ? 12 : 9.5;
    double spacing = isTablet ? 20 : 13;

    final wishlist =
        ref.watch(authRepositoryProvider.select((v) => v.wishlist));
    final cartData =
        ref.watch(authRepositoryProvider.select((v) => v.cartData));
    final isGuest =
        ref.watch(authRepositoryProvider.select((value) => value.isGuest));
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// LEFT – PROFILE AVATAR
          GestureDetector(
            onTap: () {},
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: avatarRadius,
              child: SvgPicture.asset(
                'assets/images/white.svg',
                height: iconSize + 5,
                // color: Colors.black,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              /// ❤️ WISHLIST
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: isGuest
                    ? () => _showLoginPop(context)
                    : () => context.pushRoute(const WishlistRoute()),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Image.asset(
                      'assets/images/ic_heart.png',
                      height: iconSize,
                      width: iconSize + 4,
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

              /// 🛒 CART
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: isGuest
                    ? () => _showLoginPop(context)
                    : () => context.pushRoute(const CartRoute()),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Image.asset(
                      'assets/images/ic_cart.png',
                      height: iconSize,
                      width: iconSize + 4,
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
      ),
    );
  }

  void _showLoginPop(BuildContext context) =>
      ref.read(authRepositoryProvider.notifier).showLoginPopUp(context);
}
