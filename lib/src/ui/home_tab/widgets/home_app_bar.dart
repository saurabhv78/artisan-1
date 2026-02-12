// import 'package:Artisan/src/constants/colors.dart';
// import 'package:Artisan/src/logic/repositories/auth_repository.dart';

// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:auto_route/auto_route.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'package:flutter_svg/svg.dart';
// import 'package:google_fonts/google_fonts.dart';

// import '../../../routing/router.dart';

// class HomeAppBar extends ConsumerStatefulWidget {
//   const HomeAppBar({super.key});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _HomeAppBarState();
// }

// class _HomeAppBarState extends ConsumerState<HomeAppBar> {
//   @override
//   Widget build(BuildContext context) {
//     final wishlist =
//         ref.watch(authRepositoryProvider.select((value) => value.wishlist));
//     final cartData =
//         ref.watch(authRepositoryProvider.select((value) => value.cartData));
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         GestureDetector(
//           onTap: () {},
//           child: CircleAvatar(
//             backgroundColor: Colors.white,
//             radius: 21,
//             child: SvgPicture.asset(
//               'assets/images/white.svg',
//               height: 30,
//               color: Colors.red,
//             ),
//           ),
//         ),
//         SizedBox(
//           height: 30,
//           child: Row(
//             children: [
//               // Image.asset(
//               //   'assets/images/ic_notification.png',
//               //   height: 26,
//               // ),

//               // const SizedBox(
//               //   width: 13,
//               // ),
//               GestureDetector(
//                 onTap: () {
//                   context.pushRoute(const WishlistRoute());
//                 },
//                 child: Stack(
//                   children: [
//                     Image.asset(
//                       'assets/images/ic_heart.png',
//                       height: 26,
//                       width: 30,
//                     ),
//                     if (wishlist.isNotEmpty)
//                       Positioned(
//                         right: 0,
//                         top: 0,
//                         child: Container(
//                           height: 16,
//                           width: 16,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(30),
//                             color: primaryColor,
//                           ),
//                           child: Center(
//                             child: Text(
//                               wishlist.length > 99
//                                   ? "99"
//                                   : wishlist.length.toString(),
//                               style: GoogleFonts.nunitoSans(
//                                 color: Colors.white,
//                                 fontSize: 11,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//               const SizedBox(
//                 width: 13,
//               ),
//               GestureDetector(
//                 onTap: () {
//                   context.pushRoute(const CartRoute());
//                 },
//                 child: Stack(
//                   children: [
//                     Image.asset(
//                       'assets/images/ic_cart.png',
//                       height: 26,
//                       width: 30,
//                     ),
//                     if (cartData.isNotEmpty)
//                       Positioned(
//                         right: 0,
//                         top: 0,
//                         child: Container(
//                           height: 16,
//                           width: 16,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(30),
//                             color: primaryColor,
//                           ),
//                           child: Center(
//                             child: Text(
//                               cartData.length > 99
//                                   ? "99"
//                                   : cartData.length.toString(),
//                               style: GoogleFonts.nunitoSans(
//                                 color: Colors.white,
//                                 fontSize: 11,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         )
//       ],
//     );
//   }
// }
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
    double badgeSize = isTablet ? 20 : 16;
    double badgeFont = isTablet ? 12 : 11;
    double spacing = isTablet ? 20 : 13;

    final wishlist =
        ref.watch(authRepositoryProvider.select((v) => v.wishlist));
    final cartData =
        ref.watch(authRepositoryProvider.select((v) => v.cartData));
    final isGuest =
        ref.watch(authRepositoryProvider.select((value) => value.isGuest));
    return Row(
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

        InkWell(
          onTap: isGuest
              ? () {
                  _showLoginPop(context);
                }
              : () {
                  context.pushRoute(const WishlistRoute());
                },
          child: SizedBox(
              height: iconSize,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  /// ❤️ WISHLIST
                  GestureDetector(
                    behavior: HitTestBehavior.opaque, // 👈 IMPORTANT
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
                            top: -3,
                            child: Container(
                              height: badgeSize,
                              width: badgeSize,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: primaryColor,
                              ),
                              child: Center(
                                child: Text(
                                  wishlist.length > 99
                                      ? "99"
                                      : wishlist.length.toString(),
                                  style: GoogleFonts.nunitoSans(
                                    color: Colors.white,
                                    fontSize: badgeFont,
                                    fontWeight: FontWeight.w600,
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
                    behavior: HitTestBehavior.opaque, // 👈 IMPORTANT
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
                            top: -3,
                            child: Container(
                              height: badgeSize,
                              width: badgeSize,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: primaryColor,
                              ),
                              child: Center(
                                child: Text(
                                  cartData.length > 99
                                      ? "99"
                                      : cartData.length.toString(),
                                  style: GoogleFonts.nunitoSans(
                                    color: Colors.white,
                                    fontSize: badgeFont,
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
              )
              //  Row(
              //   children: [
              //     /// ❤️ WISHLIST
              //     // GestureDetector(
              //     //   onTap: () {
              //     //     log('Navigating to Wishlist');
              //     //     context.pushRoute(const WishlistRoute());
              //     //   },
              //     // child:
              //     Stack(
              //       clipBehavior: Clip.none,
              //       children: [
              //         Image.asset(
              //           'assets/images/ic_heart.png',
              //           height: iconSize,
              //           width: iconSize + 4,
              //         ),
              //         if (wishlist.isNotEmpty)
              //           Positioned(
              //             right: -2,
              //             top: -3,
              //             child: Container(
              //               height: badgeSize,
              //               width: badgeSize,
              //               decoration: BoxDecoration(
              //                 borderRadius: BorderRadius.circular(30),
              //                 color: primaryColor,
              //               ),
              //               child: Center(
              //                 child: Text(
              //                   wishlist.length > 99
              //                       ? "99"
              //                       : wishlist.length.toString(),
              //                   style: GoogleFonts.nunitoSans(
              //                     color: Colors.white,
              //                     fontSize: badgeFont,
              //                     fontWeight: FontWeight.w600,
              //                   ),
              //                 ),
              //               ),
              //             ),
              //           ),
              //       ],
              //     ),

              //     SizedBox(width: spacing),

              //     /// 🛒 CART
              //     GestureDetector(
              //       onTap: isGuest
              //           ? () => _showLoginPop(context)
              //           : () => context.pushRoute(const CartRoute()),
              //       child: Stack(
              //         clipBehavior: Clip.none,
              //         children: [
              //           Image.asset(
              //             'assets/images/ic_cart.png',
              //             height: iconSize,
              //             width: iconSize + 4,
              //           ),
              //           if (cartData.isNotEmpty)
              //             Positioned(
              //               right: -2,
              //               top: -3,
              //               child: Container(
              //                 height: badgeSize,
              //                 width: badgeSize,
              //                 decoration: BoxDecoration(
              //                   borderRadius: BorderRadius.circular(30),
              //                   color: primaryColor,
              //                 ),
              //                 child: Center(
              //                   child: Text(
              //                     cartData.length > 99
              //                         ? "99"
              //                         : cartData.length.toString(),
              //                     style: GoogleFonts.nunitoSans(
              //                       color: Colors.white,
              //                       fontSize: badgeFont,
              //                       fontWeight: FontWeight.w600,
              //                     ),
              //                   ),
              //                 ),
              //               ),
              //             ),
              //         ],
              //       ),
              //     ),
              //   ],
              // ),

              ),
        )
      ],
    );
  }

  void _showLoginPop(BuildContext context) =>
      ref.read(authRepositoryProvider.notifier).showLoginPopUp(context);
}
