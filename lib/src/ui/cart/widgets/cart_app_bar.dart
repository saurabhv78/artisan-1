import 'package:Artisan/src/logic/repositories/auth_repository.dart';
import 'package:Artisan/src/routing/router.dart';
import 'package:Artisan/src/ui/auth/widgets/back_btn.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constants/colors.dart';

class CartAppBar extends ConsumerWidget {
  const CartAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlist =
        ref.watch(authRepositoryProvider.select((value) => value.wishlist));
    return 
    Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(25, 15, 25, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BackBtn(
              iconColor: Colors.black,
              onTap: () {
                context.maybePop();
              },
            ),
            Text(
              "My Cart",
              style: GoogleFonts.nunitoSans(
                fontWeight: FontWeight.w400,
                color: bgDark,
                fontSize: 24,
              ),
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
          ],
        ),
      ),
    );
  
  }
}
