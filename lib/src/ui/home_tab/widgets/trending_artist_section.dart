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
    final double horizontalPadding = isTablet ? 30 : 20;
    final double titleFont = isTablet ? 26 : 22;
    final double verticalSpacing = isTablet ? 20 : 15;
    final double rowSpacing = isTablet ? 20 : 16;

    if (trendingArtists.length < 2) {
      return const SizedBox();
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        children: [
          // Header Row: Title and Arrow
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Trending Artists",
                style: GoogleFonts.outfit(
                  fontSize: titleFont,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                  letterSpacing: 0.5,
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
