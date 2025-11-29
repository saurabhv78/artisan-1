// import 'package:Artisan/src/routing/router.dart';
// import 'package:Artisan/src/ui/home_tab/home_tab_page_model.dart';
// import 'package:auto_route/auto_route.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'package:google_fonts/google_fonts.dart';

// import '../../../widgets/trending_artist_card.dart';

// class TrendingArtistSection extends ConsumerWidget {
//   const TrendingArtistSection({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final trendingArtists = ref.watch(
//           homeTabPageModelProvider.select((value) => value.trendingArtists),
//         ) ??
//         [];

//     return trendingArtists.length < 2
//         ? const SizedBox()
//         : Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 22),
//             child: Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       "Trending Artists",
//                       style: GoogleFonts.nunitoSans(
//                         fontSize: 20,
//                         fontWeight: FontWeight.w700,
//                         letterSpacing: .2,
//                       ),
//                     ),
//                     GestureDetector(
//                       behavior: HitTestBehavior.opaque,
//                       onTap: () {
//                         context.navigateTo(const TrendingArtistRoute());
//                       },
//                       child: Image.asset(
//                         'assets/images/ic_arrow_forward.png',
//                         height: 24,
//                         width: 24,
//                       ),
//                     )
//                   ],
//                 ),
//                 const SizedBox(
//                   height: 15,
//                 ),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: GestureDetector(
//                         onTap: () {
//                           context.pushRoute(
//                               ProductRoute(id: trendingArtists[0].id));
//                           // context.navigateTo(ArtistRoute(
//                           //   artistData: trendingArtists[0],
//                           // ));
//                         },
//                         child: TrendingArtistsCard(
//                           data: trendingArtists[0],
//                           index: 0,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(
//                       width: 10,
//                     ),
//                     Expanded(
//                       child: GestureDetector(
//                         onTap: () {
//                           context.pushRoute(
//                               ProductRoute(id: trendingArtists[1].id));
//                           // context.navigateTo(ArtistRoute(
//                           //   artistData: trendingArtists[1],
//                           // ));
//                         },
//                         child: TrendingArtistsCard(
//                           data: trendingArtists[1],
//                           index: 1,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           );
//   }
// }
import 'package:Artisan/src/logic/repositories/auth_repository.dart';
import 'package:Artisan/src/routing/router.dart';
import 'package:Artisan/src/ui/home_tab/home_tab_page_model.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:google_fonts/google_fonts.dart';

import '../../../widgets/trending_artist_card.dart';

class TrendingArtistSection extends ConsumerWidget {
  const TrendingArtistSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trendingArtists = ref.watch(
          homeTabPageModelProvider.select((value) => value.trendingArtists),
        ) ??
        [];
    final isGuest =
        ref.watch(authRepositoryProvider.select((value) => value.isGuest));
    final width = MediaQuery.of(context).size.width;
    final isTablet = width >= 600;

    // --- Responsive Scaling ---
    final double horizontalPadding = isTablet ? 32 : 20; // टैबलेट के लिए पैडिंग
    final double titleFont = isTablet ? 28 : 20; // टाइटल फ़ॉन्ट बढ़ाया गया
    final double verticalSpacing = isTablet ? 20 : 15; // वर्टिकल स्पेसिंग
    final double rowSpacing = isTablet ? 20 : 10; // दो कार्ड के बीच की स्पेसिंग

    // यदि 2 से कम आर्टिस्ट हैं, तो खाली साइज़बॉक्स दिखाएँ
    if (trendingArtists.length < 2) {
      return const SizedBox();
    }

    return Padding(
      // हॉरिजॉन्टल पैडिंग को स्केल किया गया
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        children: [
          // Header Row: Title and Arrow
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Trending Artists",
                style: GoogleFonts.nunitoSans(
                  // टाइटल फ़ॉन्ट को स्केल किया गया
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
                        context.navigateTo(const TrendingArtistRoute());
                      },
                child: Image.asset(
                  'assets/images/ic_arrow_forward.png',
                  // टैबलेट पर आइकॉन को थोड़ा बड़ा किया जा सकता है
                  height: isTablet ? 32 : 24,
                  width: isTablet ? 32 : 24,
                ),
              )
            ],
          ),

          // Vertical Spacing
          SizedBox(height: verticalSpacing),

          // Cards Row
          Row(
            children: [
              // Card 1
              Expanded(
                child: GestureDetector(
                  onTap: isGuest
                      ? () => _showLoginPop(context, ref)
                      : () {
                          context.pushRoute(
                              ProductRoute(id: trendingArtists[0].id));
                          // context.navigateTo(ArtistRoute(
                          //   artistData: trendingArtists[0].artist, // Note: Card model `ArtistData` में `artist` ऑब्जेक्ट हो सकता है।
                          // ));
                        },
                  child: TrendingArtistsCard(
                    data: trendingArtists[0],
                    index: 0,
                  ),
                ),
              ),

              // Space between cards
              SizedBox(width: rowSpacing),

              // Card 2
              Expanded(
                child: GestureDetector(
                  onTap: isGuest
                      ? () => _showLoginPop(context, ref)
                      : () {
                          context.pushRoute(
                              ProductRoute(id: trendingArtists[1].id));
                          // context.navigateTo(ArtistRoute(
                          //   artistData: trendingArtists[1].artist,
                          // ));
                        },
                  child: TrendingArtistsCard(
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

  void _showLoginPop(BuildContext context, WidgetRef ref) =>
      ref.read(authRepositoryProvider.notifier).showLoginPopUp(context);
}
