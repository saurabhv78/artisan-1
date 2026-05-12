import 'package:Artisan/src/logic/repositories/auth_repository.dart';
import 'package:Artisan/src/routing/router.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/category_data/category_data.dart';
import '../../../widgets/components/images.dart';

class HomeCategorySection extends ConsumerWidget {
  final List<CategoryData> data;
  const HomeCategorySection({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (data.isEmpty) return const SizedBox.shrink();

    final screenWidth = MediaQuery.of(context).size.width;
    final isGuest =
        ref.watch(authRepositoryProvider.select((value) => value.isGuest));
    // Responsive sizes
    final bool isTablet = screenWidth > 600;
    final double cardWidth = isTablet ? 200 : 130;
    final double cardHeight = isTablet ? 190 : 155;
    final double imageHeight = isTablet ? 145 : 115;
    final double fontSize = isTablet ? 16 : 14;

    return SizedBox(
      height: cardHeight + 24, // Added space for vertical padding/shadows
      child: ListView.builder(
        itemCount: data.length,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(
          horizontal: isTablet ? 20 : 12,
          vertical: 12, // Space for top/bottom shadows
        ),
        itemBuilder: (context, index) {
          var item = data[index];

          return GestureDetector(
            onTap: isGuest
                ? () => _showLoginPop(context, ref)
                : () {
                    context.navigateTo(
                      ProductListRoute(
                        categoryId: item.id,
                        categoryName: item.catName,
                      ),
                    );
                  },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: _CategoryCard(
                data: item,
                width: cardWidth,
                imageHeight: imageHeight,
                fontSize: fontSize,
              ),
            ),
          );
        },
      ),
    );
  }

  void _showLoginPop(BuildContext context, WidgetRef ref) =>
      ref.read(authRepositoryProvider.notifier).showLoginPopUp(context);
}

class _CategoryCard extends StatelessWidget {
  final CategoryData data;
  final double width;
  final double imageHeight;
  final double fontSize;

  const _CategoryCard({
    super.key,
    required this.data,
    required this.width,
    required this.imageHeight,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          NetworkImageWidget(
            data.catImage,
            height: imageHeight,
            width: width,
            fit: BoxFit.cover,
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  data.catName,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
