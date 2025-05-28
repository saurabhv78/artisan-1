import 'package:Artisan/src/constants/colors.dart';
import 'package:flutter/material.dart';

import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../widgets/custom_button.dart';

class CartBottomSheet extends ConsumerWidget {
  const CartBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Sub Total",
                style: GoogleFonts.nunitoSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  letterSpacing: .4,
                  color: grayTextColor,
                ),
              ),
              Text(
                "₹10497.00",
                style: GoogleFonts.nunitoSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  letterSpacing: .1,
                  color: bgDark,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Delivery Fee",
                style: GoogleFonts.nunitoSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  letterSpacing: .4,
                  color: grayTextColor,
                ),
              ),
              Text(
                "₹497.00",
                style: GoogleFonts.nunitoSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  letterSpacing: .1,
                  color: bgDark,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Discount",
                style: GoogleFonts.nunitoSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  letterSpacing: .4,
                  color: grayTextColor,
                ),
              ),
              Text(
                "-₹297.00",
                style: GoogleFonts.nunitoSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  letterSpacing: .1,
                  color: bgDark,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 25,
            child: Row(
              children: [
                Expanded(
                  child: LayoutBuilder(builder: (context, constraints) {
                    return Dash(
                      direction: Axis.horizontal,
                      dashLength: 3,
                      length: constraints.maxWidth,
                      dashGap: 3,
                      dashColor: grayTextColor,
                      dashThickness: 1,
                    );
                  }),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total Cost",
                style: GoogleFonts.nunitoSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  letterSpacing: .4,
                  color: grayTextColor,
                ),
              ),
              Text(
                "₹10707.00",
                style: GoogleFonts.nunitoSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  letterSpacing: .1,
                  color: bgDark,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Shop More',
                    onTap: () {},
                    secondUI: true,
                    isProcessing: false,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: CustomButton(
                    text: 'Checkout',
                    onTap: () {},
                    isProcessing: false,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
