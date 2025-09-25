import 'package:Artisan/src/routing/router.dart';
import 'package:Artisan/src/widgets/product_card.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:google_fonts/google_fonts.dart';

import '../../../models/product_data/product_data.dart';

class PopularProductsSection extends ConsumerStatefulWidget {
  final List<ProductData> data;
  const PopularProductsSection({
    super.key,
    required this.data,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PopularProductsSectionState();
}

class _PopularProductsSectionState
    extends ConsumerState<PopularProductsSection> {
  @override
  Widget build(BuildContext context) {
    return widget.data.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Most Popular Work',
                maxLines: 2,
                style: GoogleFonts.nunitoSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.only(top: 10, bottom: 40),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 250,
                ),
                itemCount: widget.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      context.pushRoute(ProductRoute(
                        id: widget.data[index].id ?? '',
                        key: ValueKey(widget.data[index].id),
                      ));
                    },
                    child: ProductCard(
                      data: widget.data[index],
                      index: index,
                    ),
                  );
                },
              ),
            ],
          )
        : const SizedBox();
  }
}
