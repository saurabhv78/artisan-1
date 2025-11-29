// import 'package:Artisan/src/models/product_data/product_data.dart';
// import 'package:Artisan/src/widgets/components/images.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';

// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'package:google_fonts/google_fonts.dart';

// class ProductListCard extends ConsumerStatefulWidget {
//   final ProductData data;
//   final int index;
//   const ProductListCard({
//     super.key,
//     required this.data,
//     required this.index,
//   });

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() =>
//       _ProductListCardState();
// }

// class _ProductListCardState extends ConsumerState<ProductListCard> {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       key: ValueKey(widget.index),
//       padding: EdgeInsets.only(
//           top: 10,
//           bottom: 10,
//           right: widget.index % 2 == 0 ? 5 : 0,
//           left: widget.index % 2 != 0 ? 5 : 0),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(10),
//         child: Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10),
//             color: Colors.white,
//           ),
//           height:
//               (((widget.index + 1) % 4 == 1) || ((widget.index + 1) % 4 == 0))
//                   ? 195
//                   : 240,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               NetworkImageWidget(
//                 widget.data.thumbnail!.isNotEmpty
//                     ? widget.data.thumbnail.toString()
//                     : 'https://via.placeholder.com/150',

//                 // 'assets/images/category${(widget.index) % 3 + 1}.png',
//                 height: (((widget.index + 1) % 4 == 1) ||
//                         ((widget.index + 1) % 4 == 0))
//                     ? 165
//                     : 200,
//                 width: MediaQuery.sizeOf(context).width,
//                 fit: BoxFit.contain,
//               ),
//               Expanded(
//                 child: Container(
//                   color: Colors.white,
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 5),
//                     child: Center(
//                       child: Text(
//                         widget.data.prodName,
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                         style: GoogleFonts.nunitoSans(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w400,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:Artisan/src/models/product_data/product_data.dart';
import 'package:Artisan/src/widgets/components/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductListCard extends ConsumerStatefulWidget {
  final ProductData data;
  final int index;

  const ProductListCard({
    super.key,
    required this.data,
    required this.index,
  });

  @override
  ConsumerState<ProductListCard> createState() => _ProductListCardState();
}

class _ProductListCardState extends ConsumerState<ProductListCard> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;

    bool isTablet = screenWidth > 600;

    // सिर्फ responsive height change — UI SAME
    double smallCardHeight = isTablet ? 265 : 195;
    double bigCardHeight = isTablet ? 330 : 240;

    double smallImgHeight = isTablet ? 220 : 165;
    double bigImgHeight = isTablet ? 280 : 200;

    bool isSmallCard =
        ((widget.index + 1) % 4 == 1) || ((widget.index + 1) % 4 == 0);

    return Padding(
      key: ValueKey(widget.index),
      padding: EdgeInsets.only(
        top: 10,
        bottom: 10,
        right: widget.index % 2 == 0 ? 5 : 0,
        left: widget.index % 2 != 0 ? 5 : 0,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),

          /// 🔥 SAME UI Heights, just responsive
          height: isSmallCard ? smallCardHeight : bigCardHeight,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              /// 🔥 FIXED IMAGE — NO CUT, NO DISTORT
              SizedBox(
                height: isSmallCard ? smallImgHeight : bigImgHeight,
                child: NetworkImageWidget(
                  widget.data.thumbnail?.isNotEmpty == true
                      ? widget.data.thumbnail.toString()
                      : 'https://via.placeholder.com/150',

                  fit: BoxFit.cover, // 👈 UI change nahi, sirf image perfect
                  width: double.infinity,
                ),
              ),

              Expanded(
                child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Center(
                      child: Text(
                        widget.data.prodName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.nunitoSans(
                          fontSize: isTablet ? 20 : 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
