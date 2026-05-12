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
    final double horizontalPadding = isTablet ? 30 : 20;
    final double titleFont = isTablet ? 26 : 22;
    final double cardSize = isTablet ? 280 : 200;
    final double cardSectionHeight = cardSize + 30; // Extra space for shadows
    final double verticalSpacing = isTablet ? 15 : 12;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Text(
            "Featured",
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.w700,
              fontSize: titleFont,
              letterSpacing: 0.5,
              color: Colors.black87,
            ),
          ),
        ),
        SizedBox(height: verticalSpacing),
        SizedBox(
          height: cardSectionHeight,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: 10, // Top/bottom padding for shadows
            ),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final product = data[index];
              return Padding(
                padding: const EdgeInsets.only(right: 16),
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
    final double cardSize = isTablet ? 280 : 200;
    final double borderRadius = isTablet ? 20 : 16;
    final double titleFont = isTablet ? 22 : 16;
    final double textPosition = isTablet ? 18 : 14;

    return Container(
      width: cardSize,
      height: cardSize,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: Colors.grey.shade200,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 6),
            color: Colors.black.withOpacity(0.1),
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

          // Refined Gradient for readability
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.0, 0.5, 1.0],
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.1),
                  Colors.black.withOpacity(0.8),
                ],
              ),
            ),
            child: SizedBox(
              height: cardSize,
              width: cardSize,
            ),
          ),

          Positioned(
            bottom: textPosition,
            left: textPosition,
            right: 15,
            child: Text(
              productData.name ?? '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.w700,
                fontSize: titleFont,
                height: 1.2,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.5),
                    offset: const Offset(0, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
