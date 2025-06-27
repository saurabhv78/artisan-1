import 'package:Artisan/src/routing/router.dart';
import 'package:Artisan/src/ui/home_tab/home_tab_page_model.dart';
import 'package:Artisan/src/widgets/trending_artstyle.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../models/category_data/category_data.dart';
import '../../../widgets/components/images.dart';

// class TrendingArtStylesSection extends ConsumerStatefulWidget {
//   final List<CategoryData> categoryData;
//   const TrendingArtStylesSection({
//     super.key,
//     required this.categoryData,
//   });

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() =>
//       _TrendingArtStylesSectionState();
// }

// class _TrendingArtStylesSectionState
//     extends ConsumerState<TrendingArtStylesSection> {
//   @override
//   Widget build(BuildContext context) {
//     return widget.categoryData.length >= 2
//         ? Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 22),
//             child: Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       "Trending Art Styles",
//                       style: GoogleFonts.nunitoSans(
//                         fontSize: 20,
//                         fontWeight: FontWeight.w700,
//                         letterSpacing: .2,
//                       ),
//                     ),
//                     GestureDetector(
//                       behavior: HitTestBehavior.opaque,
//                       onTap: () {
//                         context.navigateTo(const TrendingArtStylesRoute());
//                       },
//                       child: Image.asset(
//                         'assets/images/ic_arrow_forward.png',
//                         height: 24,
//                         width: 24,
//                       ),
//                     )
//                   ],
//                 ),
//                 const SizedBox(height: 15),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: GestureDetector(
//                         onTap: () {
//                           context.navigateTo(ProductListRoute(
//                               categoryId: widget
//                                   .categoryData[widget.categoryData.length - 1]
//                                   .id,
//                               categoryName: widget
//                                   .categoryData[widget.categoryData.length - 1]
//                                   .catName));
//                         },
//                         child: _TrendingArtStyleCard(
//                           imageUrl: widget.categoryData.last.catImage ?? "",
//                           artStyle: widget
//                                   .categoryData[widget.categoryData.length - 1]
//                                   .catName ??
//                               "",
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 10),
//                     Expanded(
//                       child: GestureDetector(
//                         onTap: () {
//                           context.navigateTo(ProductListRoute(
//                               categoryId: widget
//                                   .categoryData[widget.categoryData.length - 2]
//                                   .id,
//                               categoryName: widget
//                                   .categoryData[widget.categoryData.length - 2]
//                                   .catName));
//                         },
//                         child: _TrendingArtStyleCard(
//                           imageUrl: widget
//                                   .categoryData[widget.categoryData.length - 2]
//                                   .catImage ??
//                               "",
//                           artStyle: widget
//                                   .categoryData[widget.categoryData.length - 2]
//                                   .catName ??
//                               "",
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           )
//         : const SizedBox();
//   }
// }

// class _TrendingArtStyleCard extends ConsumerWidget {
//   final String artStyle;
//   final String imageUrl;

//   const _TrendingArtStyleCard({
//     required this.imageUrl,
//     required this.artStyle,
//   });

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return LayoutBuilder(builder: (context, b) {
//       return SizedBox(
//         height: 232,
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(8),
//           child: Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(8),
//               color: Colors.white,
//               boxShadow: const [
//                 BoxShadow(
//                   color: Color.fromRGBO(0, 0, 0, 0.25),
//                   offset: Offset(1, 2),
//                   blurRadius: 4,
//                 )
//               ],
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 NetworkImageWidget(
//                   image: imageUrl,
//                   height: 200,
//                   width: b.maxWidth,
//                   fit: BoxFit.cover,
//                 ),
//                 Expanded(
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 5),
//                     child: Center(
//                       child: Text(
//                         artStyle,
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                         style: GoogleFonts.nunitoSans(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     });
//   }
// }
class TrendingArtStylesSection extends ConsumerWidget {
  const TrendingArtStylesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trendingArtists = ref.watch(
          homeTabPageModelProvider.select((value) => value.trendingArtists),
        ) ??
        [];

    return trendingArtists.length < 2
        ? const SizedBox()
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Trending Art Styles",
                      style: GoogleFonts.nunitoSans(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        letterSpacing: .2,
                      ),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        context.navigateTo(const TrendingArtStylesRoute());
                      },
                      child: Image.asset(
                        'assets/images/ic_arrow_forward.png',
                        height: 24,
                        width: 24,
                      ),
                    )
                  ],
                ),
                // const SizedBox(
                //   height: 15,
                // ),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          context.navigateTo(ArtistRoute(
                            artistData: trendingArtists[0],
                          ));
                        },
                        child: TrendingArtStyleCard(
                          data: trendingArtists[0],
                          index: 0,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          context.navigateTo(ArtistRoute(
                            artistData: trendingArtists[1],
                          ));
                        },
                        child: TrendingArtStyleCard(
                          data: trendingArtists[1],
                          index: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
  }
}
