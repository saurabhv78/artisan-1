import 'package:Artisan/src/routing/router.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../models/discount_data/discount_data.dart';

class HomeDiscountSection extends ConsumerWidget {
  final List<DiscountData> data;
  const HomeDiscountSection({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: data.isEmpty ? 0 : 131,
      child: ListView.builder(
        itemCount: data.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
              onTap: () {
                context
                    .navigateTo(ProductListRoute(discountId: data[index].id));
              },
              child: _DiscountCard(data: data[index]));
        },
      ),
    );
  }
}

class _DiscountCard extends ConsumerWidget {
  final DiscountData data;
  const _DiscountCard({
    required this.data,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: const Color(0xff141516),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.25),
                  offset: Offset(1, 2),
                  blurRadius: 4,
                )
              ]),
          height: 131,
          width: 260,
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "UPTO",
                        style: GoogleFonts.nunitoSans(
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                          letterSpacing: .02,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "${data.discountVal}% OFF",
                        style: GoogleFonts.nunitoSans(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          letterSpacing: .02,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "ON SELECTED ARTS",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.nunitoSans(
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                          letterSpacing: .02,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  )),
                ),
              ),
              Image.asset(
                'assets/images/img_discount.png',
                width: 110,
              )
            ],
          ),
        ),
      ),
    );
  }
}
