import 'package:Artisan/src/models/category_data/category_data.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../widgets/components/images.dart';

class CategoryListCard extends ConsumerStatefulWidget {
  final CategoryData data;
  final int index;
  const CategoryListCard({
    super.key,
    required this.data,
    required this.index,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CategoryListCardState();
}

class _CategoryListCardState extends ConsumerState<CategoryListCard> {
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
              NetworkImageWidget(
                widget.data.catImage,
                height: (((widget.index + 1) % 4 == 1) ||
                        ((widget.index + 1) % 4 == 0))
                    ? 165
                    : 226,
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Center(
                      child: Text(
                        widget.data.catName,
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
