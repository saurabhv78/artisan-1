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
              const SizedBox(width: 16),
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
    final double titleFont = isTablet ? 16 : 14;

    return Container(
      height: cardHeight,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 6),
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            spreadRadius: -2,
          ),
          BoxShadow(
            offset: const Offset(0, 2),
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: NetworkImageWidget(
              imageUrl,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover, // Always use cover to prevent squishing
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: Center(
              child: Text(
                artStyle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.outfit(
                  fontSize: titleFont,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLoginPop(BuildContext context, WidgetRef ref) =>
      ref.read(authRepositoryProvider.notifier).showLoginPopUp(context);
}
