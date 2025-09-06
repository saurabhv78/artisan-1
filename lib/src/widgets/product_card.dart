import 'package:Artisan/src/logic/repositories/auth_repository.dart';
import 'package:Artisan/src/ui/product/product_page_model.dart';
import 'package:Artisan/src/utils/toast_utils.dart';
import 'package:Artisan/src/widgets/components/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/colors.dart';

import '../models/product_data/product_data.dart';

class ProductCard extends ConsumerStatefulWidget {
  final ProductData data;
  final int index;
  const ProductCard({
    super.key,
    required this.data,
    required this.index,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProductCardState();
}

class _ProductCardState extends ConsumerState<ProductCard> {
  bool isProcessing = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      key: ValueKey(widget.index),
      padding: EdgeInsets.only(
          top: 10,
          bottom: 10,
          right: widget.index % 2 == 0 ? 5 : 0,
          left: widget.index % 2 != 0 ? 5 : 0),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: 170,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.shade300.withOpacity(0.5),
                    ),
                    child: NetworkImageWidget(
                      widget.data.images.isNotEmpty
                          ? widget.data.images[0]
                          : '',
                      height: 170,
                      width: MediaQuery.sizeOf(context).width,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  // crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        widget.data.prodName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.nunitoSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.star,
                      color: Color(0xffFCAF23),
                      size: 20,
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(
                      widget.data.totalRating.toStringAsFixed(1),
                      style: GoogleFonts.nunitoSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: subHead,
                      ),
                    ),
                  ],
                ),
                Text(
                  "₹${(widget.data.discountData != null ? (widget.data.prodPrice - widget.data.prodPrice * widget.data.discountData!.discountVal / 100) : widget.data.prodPrice).toStringAsFixed(2)}",
                  style: GoogleFonts.nunitoSans(
                    fontWeight: FontWeight.w400,
                    color: bgDark,
                    fontSize: 14,
                    letterSpacing: .2,
                  ),
                ),
              ],
            ),
          ),
          // Positioned(
          //   right: 10,
          //   top: 10,
          //   child: GestureDetector(
          //     onTap: () async {
          //       if (!isProcessing) {
          //         if (mounted) {
          //           setState(() {
          //             isProcessing = true;
          //           });
          //         }
          //         final res = await ref
          //             .read(authRepositoryProvider.notifier)
          //             .updateFav(widget.data.id);
          //         if (res.keys.first != true) {
          //           showErrorMessage(res.values.first);
          //         } else {
          //           showSuccessMessage(res.values.first);
          //           ref.read(authRepositoryProvider.notifier).getWishlist();
          //         }
          //         if (mounted) {
          //           setState(() {
          //             isProcessing = false;
          //           });
          //         }
          //       }
          //       ref
          //           .read(productPageModelProvider.notifier)
          //           .getProductData(widget.data.id);
          //     },
          //     child: CircleAvatar(
          //       backgroundColor: Colors.white,
          //       radius: 13,
          //       child: Icon(
          //         Icons.favorite,
          //         color: widget.data.isLiked == true

          //             // ref.watch(authRepositoryProvider.select((value) =>
          //             //             value.wishlist.indexWhere(
          //             //                 (element) => element == widget.data.id))) !=
          //             //         -1
          //             ? Colors.red
          //             : const Color(0xffC5C5C5),
          //         size: 20,
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
