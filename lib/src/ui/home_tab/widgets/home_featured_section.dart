import 'package:Artisan/src/widgets/components/images.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../models/product_data/featured_product.dart';
import '../../../models/product_data/product_data.dart';
import '../../../routing/router.dart';

class FeaturedSection extends ConsumerWidget {
  final List<FeaturedProduct> data;
  const FeaturedSection({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return (data.isEmpty)
        ? const SizedBox()
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Featured",
                  style: GoogleFonts.nunitoSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    letterSpacing: .2,
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    context.pushRoute(ProductRoute(id: data[0].id ?? ''));
                  },
                  child: _FeaturedCard(
                    index: 0,
                    productData: data[0],
                  ),
                ),
                if (data.length >= 2) ...[
                  const SizedBox(
                    height: 15,
                  ),
                  GestureDetector(
                    onTap: () {
                      context.pushRoute(ProductRoute(id: data[1].id ?? ""));
                    },
                    child: _FeaturedCard(
                      index: 1,
                      productData: data[1],
                    ),
                  ),
                ],
                if (data.length >= 3) ...[
                  const SizedBox(
                    height: 15,
                  ),
                  GestureDetector(
                    onTap: () {
                      context.pushRoute(ProductRoute(id: data[2].id ?? ''));
                    },
                    child: _FeaturedCard(
                      index: 2,
                      productData: data[2],
                    ),
                  ),
                ],
              ],
            ),
          );
  }
}

class _FeaturedCard extends ConsumerWidget {
  final FeaturedProduct productData;
  final int index;
  const _FeaturedCard({
    required this.index,
    required this.productData,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 190,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey.shade200,
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            NetworkImageWidget(
                  productData.images.isNotEmpty ? productData.images.first : '',
              fit: BoxFit.cover,
              height: 190,
              width: MediaQuery.sizeOf(context).width,
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromRGBO(255, 255, 255, 0),
                    Color.fromRGBO(0, 0, 0, .72),
                  ],
                ),
              ),
              height: 190,
              width: MediaQuery.sizeOf(context).width,
            ),
            Positioned(
              bottom: 10,
              child: Text(
                productData.name ?? '',
                style: GoogleFonts.nunitoSans(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
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
