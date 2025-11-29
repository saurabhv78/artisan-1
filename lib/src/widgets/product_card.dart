// import 'package:Artisan/src/widgets/components/images.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'package:google_fonts/google_fonts.dart';

// import '../constants/colors.dart';

// import '../models/product_data/product_data.dart';

// class ProductCard extends ConsumerStatefulWidget {
//   final ProductData data;
//   final int index;
//   const ProductCard({
//     super.key,
//     required this.data,
//     required this.index,
//   });

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _ProductCardState();
// }

// class _ProductCardState extends ConsumerState<ProductCard> {
//   bool isProcessing = false;
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       key: ValueKey(widget.index),
//       padding: EdgeInsets.only(
//           top: 10,
//           bottom: 10,
//           right: widget.index % 2 == 0 ? 5 : 0,
//           left: widget.index % 2 != 0 ? 5 : 0),
//       child: Stack(
//         children: [
//           Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(10),
//                   child: Container(
//                     height: 170,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                       color: Colors.grey.shade300.withOpacity(0.5),
//                     ),
//                     child: NetworkImageWidget(
//                       widget.data.thumbnail.toString(),
//                       height: 170,
//                       width: MediaQuery.sizeOf(context).width,
//                       fit: BoxFit.fill,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 5,
//                 ),
//                 Row(
//                   // crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     Expanded(
//                       child: Text(
//                         widget.data.prodName,
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                         style: GoogleFonts.nunitoSans(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w400,
//                           color: Colors.black,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(
//                       width: 3,
//                     ),
//                   ],
//                 ),
//                 Text(
//                   "\$${(widget.data.discountData != null ? (widget.data.prodPrice - widget.data.prodPrice * widget.data.discountData!.discountVal / 100) : widget.data.prodPrice).toStringAsFixed(2)}",
//                   style: GoogleFonts.nunitoSans(
//                     fontWeight: FontWeight.w400,
//                     color: bgDark,
//                     fontSize: 14,
//                     letterSpacing: .2,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:Artisan/src/widgets/components/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/colors.dart';
import '../models/product_data/product_data.dart';

class ProductCard extends ConsumerStatefulWidget {
  final ProductData data;
  final int index;

  const ProductCard({
    super.key,
    required this.data,
    required this.index,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProductCardState();
}

class _ProductCardState extends ConsumerState<ProductCard> {
  bool isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isTablet = width >= 600;

    // ⭐ Responsive Sizes
    final double imageHeight = isTablet ? 240 : 170;
    final double titleFont = isTablet ? 20 : 16;
    final double priceFont = isTablet ? 18 : 14;
    final double borderRadius = isTablet ? 14 : 10;

    return Padding(
      key: ValueKey(widget.index),
      padding: EdgeInsets.only(
        top: 10,
        bottom: 10,
        right: widget.index % 2 == 0 ? 5 : 0,
        left: widget.index % 2 != 0 ? 5 : 0,
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ⭐ PRODUCT IMAGE - RESPONSIVE
                ClipRRect(
                  borderRadius: BorderRadius.circular(borderRadius),
                  child: Container(
                    height: imageHeight,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300.withOpacity(0.5),
                    ),
                    child: NetworkImageWidget(
                      widget.data.thumbnail.toString(),
                      height: imageHeight,
                      width: double.infinity,
                      fit: BoxFit.cover, // ⭐ prevents stretching + cutting
                    ),
                  ),
                ),

                const SizedBox(height: 6),

                // ⭐ PRODUCT NAME
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.data.prodName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.nunitoSans(
                          fontSize: titleFont,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),

                // ⭐ PRICE WITH DISCOUNT SUPPORT
                Text(
                  "\$${(widget.data.discountData != null ? (widget.data.prodPrice - widget.data.prodPrice * widget.data.discountData!.discountVal / 100) : widget.data.prodPrice).toStringAsFixed(2)}",
                  style: GoogleFonts.nunitoSans(
                    fontWeight: FontWeight.w400,
                    color: bgDark,
                    fontSize: priceFont,
                    letterSpacing: .2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
