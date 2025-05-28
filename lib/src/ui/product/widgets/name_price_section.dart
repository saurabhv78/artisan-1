import 'package:Artisan/src/constants/colors.dart';
import 'package:Artisan/src/models/product_data/product_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class NamePriceSection extends ConsumerWidget {
  final ProductData productData;
  const NamePriceSection({
    super.key,
    required this.productData,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            productData.prodName,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.nunitoSans(
              fontWeight: FontWeight.w700,
              color: bgDark,
              fontSize: 20,
              letterSpacing: .1,
            ),
          ),
          Row(children: [
            Text(
              "₹${(productData.discountData != null ? (productData.prodPrice - productData.prodPrice * productData.discountData!.discountVal / 100) : productData.prodPrice).toStringAsFixed(2)}",
              style: GoogleFonts.nunitoSans(
                fontWeight: FontWeight.w700,
                color: bgDark,
                fontSize: 16,
                letterSpacing: .2,
              ),
            ),
            const SizedBox(
              width: 9,
            ),
            if (productData.discountData != null)
              Text(
                "₹${(productData.prodPrice).toStringAsFixed(2)}",
                style: GoogleFonts.nunitoSans(
                  fontWeight: FontWeight.w400,
                  decoration: TextDecoration.lineThrough,
                  decorationColor: grayTextColor,
                  fontSize: 12,
                  color: grayTextColor,
                  letterSpacing: .2,
                ),
              ),
          ])
        ],
      ),
    );
  }
}
