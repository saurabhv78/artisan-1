import 'package:Artisan/src/logic/repositories/auth_repository.dart';
import 'package:Artisan/src/models/wishlist_product_data/wishlist_product_data.dart';
import 'package:Artisan/src/utils/toast_utils.dart';
import 'package:Artisan/src/widgets/components/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:google_fonts/google_fonts.dart';

import '../../../constants/colors.dart';

class WishlistCard extends ConsumerStatefulWidget {
  final WishlistProductData data;
  final VoidCallback onTap;
  final int index;
  const WishlistCard({
    super.key,
    required this.data,
    required this.onTap,
    required this.index,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WishlistCardState();
}

class _WishlistCardState extends ConsumerState<WishlistCard> {
  bool isProcessing = false;
  @override
  Widget build(BuildContext context) {
    return widget.data.isRemoved
        ? const SizedBox()
        : Padding(
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
                          height: 160,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey.shade300.withOpacity(0.5),
                          ),
                          child: NetworkImageWidget(
                            widget.data.prodMedia[0].toString() ?? '',
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
                          // Text(
                          //   widget.data.totalRating.toStringAsFixed(1),
                          //   style: GoogleFonts.nunitoSans(
                          //     fontSize: 12,
                          //     fontWeight: FontWeight.w400,
                          //     color: subHead,
                          //   ),
                          // ),
                        ],
                      ),
                      Text(
                        "₹${widget.data.prodPrice.toStringAsFixed(2)}",
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
                Positioned(
                  right: 10,
                  top: 10,
                  child: GestureDetector(
                    onTap: () async {
                      if (!isProcessing) {
                        if (mounted) {
                          setState(() {
                            isProcessing = true;
                          });
                        }
                        final res = await ref
                            .read(authRepositoryProvider.notifier)
                            .updateFav(widget.data.prodId);

                        if (res.keys.first != true) {
                          showErrorMessage(res.values.first);
                        } else {
                          showSuccessMessage(res.values.first);
                          widget.onTap();
                        }
                        if (mounted) {
                          setState(() {
                            isProcessing = false;
                          });
                        }
                      }
                    },
                    child: const CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 13,
                      child: Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
