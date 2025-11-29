// import 'package:Artisan/src/widgets/components/images.dart';
// import 'package:auto_route/auto_route.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../../../models/product_data/featured_product.dart';
// import '../../../routing/router.dart';

// class FeaturedSection extends ConsumerWidget {
//   final List<FeaturedProduct> data;
//   const FeaturedSection({super.key, required this.data});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     if (data.isEmpty) return const SizedBox();

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 22),
//           child: Text(
//             "Featured",
//             style: GoogleFonts.nunitoSans(
//               fontWeight: FontWeight.w700,
//               fontSize: 20,
//               letterSpacing: .2,
//             ),
//           ),
//         ),
//         const SizedBox(height: 10),
//         SizedBox(
//           height: 190,
//           child: ListView.builder(
//             scrollDirection: Axis.horizontal,
//             padding: const EdgeInsets.symmetric(horizontal: 22),
//             itemCount: data.length,
//             itemBuilder: (context, index) {
//               final product = data[index];
//               return Padding(
//                 padding: const EdgeInsets.only(right: 15),
//                 child: GestureDetector(
//                   onTap: () {
//                     context.pushRoute(ProductRoute(id: product.id ?? ''));
//                   },
//                   child: _FeaturedCard(
//                     index: index,
//                     productData: product,
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _FeaturedCard extends StatelessWidget {
//   final FeaturedProduct productData;
//   final int index;
//   const _FeaturedCard({required this.index, required this.productData});

//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(8),
//       child: Container(
//         width: 200, // fixed width for horizontal list
//         height: 200,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(8),
//           color: Colors.grey.shade200,
//         ),
//         child: Stack(
//           alignment: Alignment.bottomCenter,
//           children: [
//             NetworkImageWidget(
//               productData.thumbnail!.isNotEmpty
//                   ? productData.thumbnail.toString()
//                   : '',
//               fit: BoxFit.fill,
//               height: 200,
//               width: 200,
//             ),
//             // Container(
//             //   decoration: const BoxDecoration(
//             //     gradient: LinearGradient(
//             //       begin: Alignment.topCenter,
//             //       end: Alignment.bottomCenter,
//             //       colors: [
//             //         Color.fromRGBO(255, 255, 255, 0),
//             //         Color.fromRGBO(0, 0, 0, .72),
//             //       ],
//             //     ),
//             //   ),
//             //   height: 190,
//             //   width: 260,
//             //  ),
//             Positioned(
//               bottom: 10,
//               left: 15,
//               right: 10,
//               child: Text(
//                 productData.name ?? '',
//                 style: GoogleFonts.nunitoSans(
//                   fontWeight: FontWeight.w700,
//                   fontSize: 16,
//                   letterSpacing: .2,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:Artisan/src/logic/repositories/auth_repository.dart';
import 'package:Artisan/src/widgets/components/images.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/product_data/featured_product.dart';
import '../../../routing/router.dart';

class FeaturedSection extends ConsumerWidget {
  final List<FeaturedProduct> data;
  const FeaturedSection({super.key, required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isGuest =
        ref.watch(authRepositoryProvider.select((value) => value.isGuest));
    if (data.isEmpty) return const SizedBox();

    final width = MediaQuery.of(context).size.width;
    final isTablet = width >= 600;

    // --- Responsive Scaling ---
    final double horizontalPadding = isTablet ? 32 : 20; // पैडिंग बढ़ाई गई
    final double titleFont = isTablet ? 28 : 20; // टाइटल फ़ॉन्ट बढ़ाया गया
    final double cardSectionHeight =
        isTablet ? 300 : 190; // कार्ड सेक्शन की ऊंचाई बढ़ाई गई
    final double verticalSpacing = isTablet ? 15 : 10; // वर्टिकल स्पेसिंग

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          // हॉरिजॉन्टल पैडिंग को स्केल किया गया
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Text(
            "Featured",
            style: GoogleFonts.nunitoSans(
              fontWeight: FontWeight.w700,
              fontSize: titleFont,
              letterSpacing: .2,
            ),
          ),
        ),
        SizedBox(height: verticalSpacing),
        SizedBox(
          height: cardSectionHeight,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            // ListView की पैडिंग को स्केल किया गया
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final product = data[index];
              return Padding(
                // कार्ड के बीच की स्पेसिंग को स्केल किया जा सकता है,
                // लेकिन 15 पर्याप्त है
                padding: const EdgeInsets.only(right: 15),
                child: GestureDetector(
                  onTap: isGuest
                      ? () => _showLoginPop(context, ref)
                      : () {
                          // सुनिश्चित करें कि id null न हो
                          if (product.id != null) {
                            context.pushRoute(ProductRoute(id: product.id!));
                          }
                        },
                  child: _FeaturedCard(
                    index: index,
                    productData: product,
                    isTablet: isTablet,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showLoginPop(BuildContext context, WidgetRef ref) =>
      ref.read(authRepositoryProvider.notifier).showLoginPopUp(context);
}

class _FeaturedCard extends StatelessWidget {
  final FeaturedProduct productData;
  final int index;
  final bool isTablet;

  const _FeaturedCard({
    required this.index,
    required this.productData,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    // --- Responsive Scaling ---
    final double cardSize =
        isTablet ? 280 : 200; // कार्ड की चौड़ाई/ऊँचाई को बढ़ाया गया
    final double borderRadius = isTablet ? 16 : 8; // बॉर्डर रेडियस बढ़ाया गया
    final double titleFont = isTablet ? 22 : 16; // टाइटल फ़ॉन्ट बढ़ाया गया
    final double textPosition =
        isTablet ? 18 : 12; // टेक्स्ट पोजीशन (left/bottom)

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        width: cardSize,
        height: cardSize, // कार्ड चौकोर रहेगा
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: Colors.grey.shade200,
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // Product Image
            NetworkImageWidget(
              productData.thumbnail?.isNotEmpty == true
                  ? productData.thumbnail.toString()
                  : '',
              fit: BoxFit.cover,
              height: cardSize,
              width: cardSize,
            ),

            // Gradient for readability
            Container(
              height: cardSize,
              width: cardSize,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromRGBO(0, 0, 0, 0),
                    Color.fromRGBO(
                        0, 0, 0, .65), // ग्रेडिएंट को थोड़ा गहरा किया
                  ],
                ),
              ),
            ),

            Positioned(
              bottom: textPosition,
              left: textPosition,
              right: 10,
              child: Text(
                productData.name ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.nunitoSans(
                  fontWeight: FontWeight.w700,
                  fontSize: titleFont,
                  letterSpacing: .2,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
