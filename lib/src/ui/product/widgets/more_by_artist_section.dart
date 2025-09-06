import 'package:Artisan/src/routing/router.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constants/colors.dart';
import '../../../models/product_data/product_data.dart';
import '../../../widgets/components/images.dart';

class MoreByArtistSection extends ConsumerWidget {
  final List<ProductData> products;
  final ProductData data;
  const MoreByArtistSection({
    super.key,
    required this.data,
    required this.products,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 22),
          child: Text(
            "More by the artist",
            style: GoogleFonts.nunitoSans(
              fontWeight: FontWeight.w400,
              color: bgDark,
              fontSize: 16,
              letterSpacing: -.1,
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 155,
          child: ListView.builder(
            itemCount: products.length,
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.only(left: 7),
                child: products[index].id != data.id
                    ? GestureDetector(
                        onTap: () {
                          context.replaceRoute(
                            ProductRoute(
                              id: products[index].id,
                              key: ValueKey(
                                products[index],
                              ),
                            ),
                          );
                        },
                        child: _ArtistArtCard(
                          data: products[index],
                          imageUrl: products[index].images.isNotEmpty
                              ? products[index].images[0]
                              : '',
                          // price: "₹2999.00",
                        ),
                      )
                    : const SizedBox(),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ArtistArtCard extends ConsumerWidget {
  final String imageUrl;
  final ProductData data;
  const _ArtistArtCard({
    required this.data,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: 110,
      child: LayoutBuilder(builder: (context, b) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: NetworkImageWidget(
                imageUrl,
                height: b.maxHeight / 2,
                width: b.maxWidth,
                fit: BoxFit.cover,
              ),
            ),
            Text(
              maxLines: 2,
              data.prodName,
              style: GoogleFonts.nunitoSans(
                fontWeight: FontWeight.w400,
                color: blackPrimaryColor,
                fontSize: 14,
                // letterSpacing: .2,
              ),
            ),
            Text(
              "₹${data.prodPrice.toStringAsFixed(2)}",
              style: GoogleFonts.nunitoSans(
                fontWeight: FontWeight.w700,
                color: blackPrimaryColor,
                fontSize: 12,
                // letterSpacing: .2,
              ),
            ),
          ],
        );
      }),
    );
  }
}
