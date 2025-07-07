import 'package:Artisan/src/logic/repositories/auth_repository.dart';
import 'package:Artisan/src/models/wishlist_product_data/wishlist_product_data.dart';
import 'package:Artisan/src/routing/router.dart';
import 'package:Artisan/src/ui/wishlist/wishlist_page_model.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'wishlist_card.dart';

class WishListSection extends ConsumerStatefulWidget {
  final List<WishlistProductData> data;
  const WishListSection({
    super.key,
    required this.data,
  });

  @override
  ConsumerState<WishListSection> createState() => _WishListSection();
}

class _WishListSection extends ConsumerState<WishListSection> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 10, bottom: 40),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 240,
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
          child: WishlistCard(
            onTap: () async {
              ref.read(authRepositoryProvider.notifier).getWishlist();
              ref
                  .read(wishlistPageModelProvider.notifier)
                  .removeProduct(widget.data[index].id ?? '');
            },
            data: widget.data[index],
            index: index,
          ),
        );
      },
    );
  }
}
