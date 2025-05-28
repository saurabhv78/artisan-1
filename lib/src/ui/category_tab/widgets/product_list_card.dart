import 'package:Artisan/src/models/product_data/product_data.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductListCard extends ConsumerStatefulWidget {
  final ProductData data;
  final int index;
  const ProductListCard({
    super.key,
    required this.data,
    required this.index,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProductListCardState();
}

class _ProductListCardState extends ConsumerState<ProductListCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      key: ValueKey(widget.index),
      padding: EdgeInsets.only(
          top: 10,
          bottom: 10,
          right: widget.index % 2 == 0 ? 5 : 0,
          left: widget.index % 2 != 0 ? 5 : 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey.shade300.withOpacity(0.5),
          ),
          height:
              (((widget.index + 1) % 4 == 1) || ((widget.index + 1) % 4 == 0))
                  ? 195
                  : 265,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                'assets/images/category${(widget.index) % 3 + 1}.png',
                height: (((widget.index + 1) % 4 == 1) ||
                        ((widget.index + 1) % 4 == 0))
                    ? 165
                    : 226,
                width: MediaQuery.sizeOf(context).width,
                fit: BoxFit.fill,
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Center(
                      child: Text(
                        widget.data.prodName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.nunitoSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
