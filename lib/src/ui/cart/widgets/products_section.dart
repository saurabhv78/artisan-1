import 'package:Artisan/src/ui/cart/cart_page_model.dart';
import 'package:Artisan/src/utils/toast_utils.dart';
import 'package:Artisan/src/widgets/components/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:google_fonts/google_fonts.dart';

import '../../../constants/colors.dart';

import 'package:Artisan/src/logic/repositories/auth_repository.dart';
import 'package:Artisan/src/routing/router.dart';
import 'package:Artisan/src/ui/wishlist/wishlist_page_model.dart';
import 'package:auto_route/auto_route.dart';

import '../../../models/cart_data/cart_data.dart';

class CartProductListSection extends ConsumerStatefulWidget {
  final List<CartItem> data;
  const CartProductListSection({
    super.key,
    required this.data,
  });

  @override
  ConsumerState<CartProductListSection> createState() =>
      _CartProductListSection();
}

class _CartProductListSection extends ConsumerState<CartProductListSection> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: widget.data.isEmpty
          ? const SizedBox(
              height: 300,
              child: Center(child: Text("No Item Found in the cart")),
            )
          : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.only(top: 0, bottom: 10),
              itemCount: widget.data.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    context.pushRoute(ProductRoute(
                      id: widget.data[index].id,
                      key: ValueKey(widget.data[index].id),
                    ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: _CartProductCard(
                      onTap: () async {
                        ref.read(authRepositoryProvider.notifier).getWishlist();
                        ref
                            .read(wishlistPageModelProvider.notifier)
                            .removeProduct(widget.data[index].id);
                      },
                      data: widget.data[index],
                      index: index,
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class _CartProductCard extends ConsumerStatefulWidget {
  final CartItem data;
  final int index;
  final VoidCallback onTap;
  const _CartProductCard({
    required this.data,
    required this.onTap,
    required this.index,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      __CartProductCardState();
}

class __CartProductCardState extends ConsumerState<_CartProductCard> {
  bool isProcessing = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushRoute(ProductRoute(id: widget.data.id));
      },
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4.5),
            child: NetworkImageWidget(
              widget.data.image ?? '',
              height: 86,
              width: 86,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  widget.data.name ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.nunitoSans(
                    fontWeight: FontWeight.w700,
                    color: blackPrimaryColor,
                    fontSize: 20,
                    letterSpacing: -.1,
                  ),
                ),
                Text(
                  widget.data.name ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.nunitoSans(
                    fontWeight: FontWeight.w400,
                    color: grayTextColor,
                    fontSize: 16,
                    letterSpacing: -.1,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Text(
            "₹${(widget.data.price ?? 0).toStringAsFixed(2)}",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.nunitoSans(
              fontWeight: FontWeight.w700,
              color: bgDark,
              fontSize: 16,
              letterSpacing: .1,
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          GestureDetector(
            onTap: () async {
              if (!isProcessing) {
                if (mounted) {
                  setState(() {
                    isProcessing = true;
                  });
                }
                final res = await ref
                    .read(cartPageModelProvider.notifier)
                    .removeFromCart(
                        widget.data.id, widget.data.discountAmt ?? 0);
                if (res.keys.first != true) {
                  showErrorMessage(res.values.first);
                } else {
                  showSuccessMessage(res.values.first);
                }
                if (mounted) {
                  setState(() {
                    isProcessing = false;
                  });
                }
              }
            },
            child: Image.asset(
              'assets/images/ic_delete.png',
              height: 24,
              width: 24,
            ),
          ),
        ],
      ),
    );
  }
}
