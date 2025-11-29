// import 'package:Artisan/src/models/artstyle_data/art_style_data.dart';
// import 'package:Artisan/src/routing/router.dart';
// import 'package:auto_route/auto_route.dart';
// import 'package:flutter/material.dart';

// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'package:google_fonts/google_fonts.dart';
// import '../../../widgets/components/images.dart';

// class TrendingArtStylesSection extends ConsumerStatefulWidget {
//   final List<ArtStyle> trendingArtists;
//   const TrendingArtStylesSection({
//     super.key,
//     required this.trendingArtists,
//   });

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() =>
//       _TrendingArtStylesSectionState();
// }

// class _TrendingArtStylesSectionState
//     extends ConsumerState<TrendingArtStylesSection> {
//   @override
//   Widget build(BuildContext context) {
//     return widget.trendingArtists.length >= 2
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
//                           // context.pushRoute(ProductRoute(
//                           //     id: widget
//                           //             .trendingArtists[
//                           //                 widget.trendingArtists.length - 1]
//                           //             .id ??
//                           //         ""));
//                           context.navigateTo(ProductListRoute(
//                               artStyleId: widget
//                                   .trendingArtists[
//                                       widget.trendingArtists.length - 1]
//                                   .id,
//                               categoryName: widget
//                                   .trendingArtists[
//                                       widget.trendingArtists.length - 1]
//                                   .name));
//                         },
//                         child: _TrendingArtStyleCard(
//                           imageUrl: widget.trendingArtists.last.file ?? "",
//                           artStyle: widget
//                                   .trendingArtists[
//                                       widget.trendingArtists.length - 1]
//                                   .name ??
//                               "",
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 10),
//                     Expanded(
//                       child: GestureDetector(
//                         onTap: () {
//                           context.navigateTo(ProductListRoute(
//                               artStyleId: widget
//                                   .trendingArtists[
//                                       widget.trendingArtists.length - 2]
//                                   .id,
//                               categoryName: widget
//                                   .trendingArtists[
//                                       widget.trendingArtists.length - 2]
//                                   .name));
//                           // context.pushRoute(ProductRoute(
//                           //     id: widget
//                           //             .trendingArtists[
//                           //                 widget.trendingArtists.length - 2]
//                           //             .id ??
//                           //         ""));
//                         },
//                         child: _TrendingArtStyleCard(
//                           imageUrl: widget
//                                   .trendingArtists[
//                                       widget.trendingArtists.length - 2]
//                                   .file ??
//                               "",
//                           artStyle: widget
//                                   .trendingArtists[
//                                       widget.trendingArtists.length - 2]
//                                   .name ??
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
//                   imageUrl,
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
import 'package:Artisan/src/logic/repositories/auth_repository.dart';
import 'package:Artisan/src/models/artstyle_data/art_style_data.dart';
import 'package:Artisan/src/routing/router.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../widgets/components/images.dart';

class TrendingArtStylesSection extends ConsumerStatefulWidget {
  final List<ArtStyle> trendingArtists;
  const TrendingArtStylesSection({
    super.key,
    required this.trendingArtists,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TrendingArtStylesSectionState();
}

class _TrendingArtStylesSectionState
    extends ConsumerState<TrendingArtStylesSection> {
  @override
  Widget build(BuildContext context) {
    final isGuest =
        ref.watch(authRepositoryProvider.select((value) => value.isGuest));
    if (widget.trendingArtists.length < 2) return const SizedBox();

    final width = MediaQuery.of(context).size.width;
    final isTablet = width >= 600;

    final double titleFont = isTablet ? 26 : 20;
    final double cardHeight = isTablet ? 300 : 232;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isTablet ? 28 : 22),
      child: Column(
        children: [
          // Title Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Trending Art Styles",
                style: GoogleFonts.nunitoSans(
                  fontSize: titleFont,
                  fontWeight: FontWeight.w700,
                  letterSpacing: .2,
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: isGuest
                    ? () => _showLoginPop(context, ref)
                    : () {
                        context.navigateTo(const TrendingArtStylesRoute());
                      },
                child: Image.asset(
                  'assets/images/ic_arrow_forward.png',
                  height: isTablet ? 30 : 24,
                  width: isTablet ? 30 : 24,
                ),
              )
            ],
          ),

          const SizedBox(height: 15),

          // Two Cards Row
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: isGuest
                      ? () => _showLoginPop(context, ref)
                      : () {
                          final item = widget.trendingArtists.last;
                          context.navigateTo(ProductListRoute(
                            artStyleId: item.id,
                            categoryName: item.name,
                          ));
                        },
                  child: _TrendingArtStyleCard(
                    imageUrl: widget.trendingArtists.last.file ?? "",
                    artStyle: widget.trendingArtists.last.name ?? "",
                    isTablet: isTablet,
                    cardHeight: cardHeight,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: isGuest
                      ? () => _showLoginPop(context, ref)
                      : () {
                          final item = widget.trendingArtists[
                              widget.trendingArtists.length - 2];
                          context.navigateTo(ProductListRoute(
                            artStyleId: item.id,
                            categoryName: item.name,
                          ));
                        },
                  child: _TrendingArtStyleCard(
                    imageUrl: widget
                            .trendingArtists[widget.trendingArtists.length - 2]
                            .file ??
                        "",
                    artStyle: widget
                            .trendingArtists[widget.trendingArtists.length - 2]
                            .name ??
                        "",
                    isTablet: isTablet,
                    cardHeight: cardHeight,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showLoginPop(BuildContext context, WidgetRef ref) =>
      ref.read(authRepositoryProvider.notifier).showLoginPopUp(context);
}

class _TrendingArtStyleCard extends StatelessWidget {
  final String artStyle;
  final String imageUrl;
  final bool isTablet;
  final double cardHeight;

  const _TrendingArtStyleCard({
    required this.imageUrl,
    required this.artStyle,
    required this.isTablet,
    required this.cardHeight,
  });

  @override
  Widget build(BuildContext context) {
    final double titleFont = isTablet ? 16 : 12;

    return SizedBox(
      height: cardHeight,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(isTablet ? 12 : 8),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(isTablet ? 12 : 8),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.25),
                offset: Offset(1, 2),
                blurRadius: 4,
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              /// 🔥 FIXED IMAGE STRETCH USING ASPECT RATIO
              AspectRatio(
                aspectRatio: isTablet ? 13 / 9 : 2 / 2.2,
                child: NetworkImageWidget(
                  imageUrl,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.fill,
                ),
              ),

              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Text(
                      artStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.nunitoSans(
                        fontSize: titleFont,
                        fontWeight: FontWeight.w700,
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

  void _showLoginPop(BuildContext context, WidgetRef ref) =>
      ref.read(authRepositoryProvider.notifier).showLoginPopUp(context);
}
