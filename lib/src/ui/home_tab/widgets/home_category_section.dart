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
    return SizedBox(
      height: data.isEmpty ? 0 : 151,
      child: ListView.builder(
        itemCount: data.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        itemBuilder: (BuildContext context, int index) {
          var item = data[index];
          return GestureDetector(
            onTap: () {
              context.navigateTo(
                ProductListRoute(
                  categoryId: item.id,
                  categoryName: item.catName,
                ),
              );
            },
            child: _CategoryCard(
              index: index,
              data: item,
            ),
          );
        },
      ),
    );
  }
}

class _CategoryCard extends ConsumerWidget {
  final CategoryData data;
  final int index;

  const _CategoryCard({
    required this.index,
    required this.data,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(left: 7),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                offset: Offset(0, 2),
                color: Color.fromRGBO(161, 161, 161, 0.25),
              ),
            ],
          ),
          child: Column(
            children: [
              NetworkImageWidget(
                 data.catImage,
                height: 121,
                width: 131,
                fit: BoxFit.cover,
              ),
              const SizedBox(
                height: 5
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    data.catName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.nunitoSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
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
