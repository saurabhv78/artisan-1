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
    if (data.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Text(
            "Featured",
            style: GoogleFonts.nunitoSans(
              fontWeight: FontWeight.w700,
              fontSize: 20,
              letterSpacing: .2,
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 190,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 22),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final product = data[index];
              return Padding(
                padding: const EdgeInsets.only(right: 15),
                child: GestureDetector(
                  onTap: () {
                    context.pushRoute(ProductRoute(id: product.id ?? ''));
                  },
                  child: _FeaturedCard(
                    index: index,
                    productData: product,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  final FeaturedProduct productData;
  final int index;
  const _FeaturedCard({required this.index, required this.productData});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 200, // fixed width for horizontal list
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey.shade200,
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            NetworkImageWidget(
              productData.thumbnail!.isNotEmpty
                  ? productData.thumbnail.toString()
                  : '',
              fit: BoxFit.fill,
              height: 200,
              width: 200,
            ),
            // Container(
            //   decoration: const BoxDecoration(
            //     gradient: LinearGradient(
            //       begin: Alignment.topCenter,
            //       end: Alignment.bottomCenter,
            //       colors: [
            //         Color.fromRGBO(255, 255, 255, 0),
            //         Color.fromRGBO(0, 0, 0, .72),
            //       ],
            //     ),
            //   ),
            //   height: 190,
            //   width: 260,
            //  ),
            Positioned(
              bottom: 10,
              left: 15,
              right: 10,
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
