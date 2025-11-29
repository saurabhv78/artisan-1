// import 'dart:ui';

// import 'package:Artisan/src/logic/repositories/auth_repository.dart';
// import 'package:Artisan/src/models/wishlist_product_data/wishlist_product_data.dart';
// import 'package:Artisan/src/utils/toast_utils.dart';
// import 'package:Artisan/src/widgets/components/images.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'package:google_fonts/google_fonts.dart';

// import '../../../constants/colors.dart';

// class WishlistCard extends ConsumerStatefulWidget {
//   final WishlistProductData data;
//   final VoidCallback onTap;
//   final int index;
//   const WishlistCard({
//     super.key,
//     required this.data,
//     required this.onTap,
//     required this.index,
//   });

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _WishlistCardState();
// }

// class _WishlistCardState extends ConsumerState<WishlistCard> {
//   bool isProcessing = false;
//   @override
//   Widget build(BuildContext context) {
//     return widget.data.isRemoved
//         ? const SizedBox()
//         : Padding(
//             key: ValueKey(widget.index),
//             padding: EdgeInsets.only(
//                 top: 10,
//                 bottom: 10,
//                 right: widget.index % 2 == 0 ? 5 : 0,
//                 left: widget.index % 2 != 0 ? 5 : 0),
//             child: Stack(
//               children: [
//                 Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: [
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(10),
//                         child: Stack(
//                           children: [
//                             Container(
//                               height: 160,
//                               decoration: BoxDecoration(
//                                 color: Colors.grey.shade300.withOpacity(0.5),
//                               ),
//                               child: NetworkImageWidget(
//                                 widget.data.prodMedia[0].toString(),
//                                 height: 170,
//                                 width: MediaQuery.sizeOf(context).width,
//                                 fit: BoxFit.cover,
//                               ),
//                             ),

//                             // Blur when sold
//                             if (widget.data.isSold == true)
//                               Positioned.fill(
//                                 child: BackdropFilter(
//                                   filter:
//                                       ImageFilter.blur(sigmaX: 5, sigmaY: 5),
//                                   child: Container(
//                                     color: Colors.black
//                                         .withOpacity(0.3), // dark overlay
//                                   ),
//                                 ),
//                               ),

//                             // SOLD text
//                             if (widget.data.isSold == true)
//                               Positioned(
//                                 top: 50,
//                                 left: 20,
//                                 right: 0,
//                                 bottom: 0,
//                                 child: Text(
//                                   "SOLD OUT",
//                                   style: GoogleFonts.nunitoSans(
//                                     fontSize: 26,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.white,
//                                     shadows: [
//                                       Shadow(
//                                         offset: Offset(1, 1),
//                                         blurRadius: 4,
//                                         color: Colors.black87,
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 5,
//                       ),
//                       Row(
//                         // crossAxisAlignment: CrossAxisAlignment.end,
//                         children: [
//                           Expanded(
//                             child: Text(
//                               widget.data.prodName,
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                               style: GoogleFonts.nunitoSans(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w400,
//                                 color: Colors.black,
//                               ),
//                             ),
//                           ),
//                           // const Icon(
//                           //   Icons.star,
//                           //   color: Color(0xffFCAF23),
//                           //   size: 20,
//                           // ),
//                           const SizedBox(
//                             width: 3,
//                           ),
//                           // Text(
//                           //   widget.data.totalRating.toStringAsFixed(1),
//                           //   style: GoogleFonts.nunitoSans(
//                           //     fontSize: 12,
//                           //     fontWeight: FontWeight.w400,
//                           //     color: subHead,
//                           //   ),
//                           // ),
//                         ],
//                       ),
//                       Text(
//                         "\$${widget.data.prodPrice.toStringAsFixed(2)}",
//                         style: GoogleFonts.nunitoSans(
//                           fontWeight: FontWeight.w400,
//                           color: bgDark,
//                           fontSize: 14,
//                           letterSpacing: .2,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Positioned(
//                   right: 10,
//                   top: 10,
//                   child: GestureDetector(
//                     onTap: () async {
//                       if (!isProcessing) {
//                         if (mounted) {
//                           setState(() {
//                             isProcessing = true;
//                           });
//                         }
//                         final res = await ref
//                             .read(authRepositoryProvider.notifier)
//                             .updateFav(widget.data.prodId);

//                         if (res.keys.first != true) {
//                           showErrorMessage(res.values.first);
//                         } else {
//                           showSuccessMessage(res.values.first);
//                           widget.onTap();
//                         }
//                         if (mounted) {
//                           setState(() {
//                             isProcessing = false;
//                           });
//                         }
//                       }
//                     },
//                     child: const CircleAvatar(
//                       backgroundColor: Colors.white,
//                       radius: 13,
//                       child: Icon(
//                         Icons.favorite,
//                         color: Colors.red,
//                         size: 20,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//   }
// }
import 'dart:ui';

import 'package:Artisan/src/logic/repositories/auth_repository.dart';
import 'package:Artisan/src/models/wishlist_product_data/wishlist_product_data.dart';
import 'package:Artisan/src/utils/toast_utils.dart';
import 'package:Artisan/src/widgets/components/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constants/colors.dart';

class WishlistCard extends ConsumerStatefulWidget {
  final WishlistProductData data;
  final VoidCallback onTap;
  final int index;
  const WishlistCard({
    super.key,
    required this.data,
    required this.onTap,
    required this.index,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WishlistCardState();
}

class _WishlistCardState extends ConsumerState<WishlistCard> {
  bool isProcessing = false;

  @override
  Widget build(BuildContext context) {
    if (widget.data.isRemoved) return const SizedBox();

    final width = MediaQuery.of(context).size.width;
    final isTablet = width >= 600;

    // Responsive values
    final double imageHeight = isTablet ? 240 : 160;
    final double nameFont = isTablet ? 18 : 16;
    final double priceFont = isTablet ? 16 : 14;
    final double favRadius = isTablet ? 16 : 13;
    final double soldFont = isTablet ? 32 : 26;
    final double paddingLR = isTablet ? 12 : 5;

    return Padding(
      key: ValueKey(widget.index),
      padding: EdgeInsets.only(
        top: 10,
        bottom: 10,
        right: widget.index % 2 == 0 ? paddingLR : 0,
        left: widget.index % 2 != 0 ? paddingLR : 0,
      ),
      child: Stack(
        children: [
          // Card container
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image with SOLD overlay
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  children: [
                    SizedBox(
                      height: imageHeight,
                      width: double.infinity,
                      child: NetworkImageWidget(
                        widget.data.prodMedia[0].toString(),
                        fit: BoxFit.cover,
                        // width: double.infinity,
                        // height: double.infinity,
                      ),
                    ),

                    // Blur when sold
                    if (widget.data.isSold == true)
                      Positioned.fill(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: Container(
                            color:
                                Colors.black.withOpacity(0.3), // dark overlay
                          ),
                        ),
                      ),

                    // SOLD text
                    if (widget.data.isSold == true)
                      Positioned.fill(
                        child: Center(
                            child: Text(
                          "SOLD OUT",
                          style: GoogleFonts.nunitoSans(
                            fontSize: soldFont,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: const [
                              Shadow(
                                offset: Offset(1, 1),
                                blurRadius: 4,
                                color: Colors.black87,
                              )
                            ],
                          ),
                        )),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 5),

              // Product name & price
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.data.prodName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.nunitoSans(
                        fontSize: nameFont,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                "\$${widget.data.prodPrice.toStringAsFixed(2)}",
                style: GoogleFonts.nunitoSans(
                  fontWeight: FontWeight.w400,
                  color: bgDark,
                  fontSize: priceFont,
                  letterSpacing: .2,
                ),
              ),
            ],
          ),

          // Favorite icon
          Positioned(
            right: 10,
            top: 10,
            child: GestureDetector(
              onTap: () async {
                if (!isProcessing) {
                  if (mounted) setState(() => isProcessing = true);

                  final res = await ref
                      .read(authRepositoryProvider.notifier)
                      .updateFav(widget.data.prodId);

                  if (res.keys.first != true) {
                    showErrorMessage(res.values.first);
                  } else {
                    showSuccessMessage(res.values.first);
                    widget.onTap();
                  }

                  if (mounted) setState(() => isProcessing = false);
                }
              },
              child: CircleAvatar(
                radius: favRadius,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.favorite,
                  color: Colors.red,
                  size: favRadius + 7,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
