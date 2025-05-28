import 'package:Artisan/src/routing/router.dart';
import 'package:Artisan/src/ui/home_tab/home_tab_page_model.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../widgets/trending_artist_card.dart';

class TrendingArtistSection extends ConsumerWidget {
  const TrendingArtistSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trendingArtists = ref.watch(homeTabPageModelProvider
            .select((value) => value.trendingArtists)) ??
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
                      "Trending Artists",
                      style: GoogleFonts.nunitoSans(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        letterSpacing: .2,
                      ),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        context.navigateTo(const TrendingArtistRoute());
                      },
                      child: Image.asset(
                        'assets/images/ic_arrow_forward.png',
                        height: 24,
                        width: 24,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          context.navigateTo(ArtistRoute(
                            artistData: trendingArtists[0].artistData,
                          ));
                        },
                        child: TrendingArtistsCard(
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
                            artistData: trendingArtists[1].artistData,
                          ));
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
}
