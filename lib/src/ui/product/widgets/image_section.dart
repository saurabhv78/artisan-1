import 'dart:developer';
import 'package:Artisan/src/ui/auth/widgets/back_btn.dart';
import 'package:Artisan/src/ui/product/widgets/product_view.dart';
import 'package:Artisan/src/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../logic/repositories/auth_repository.dart';
import '../../../models/product_data/product_data.dart';
import '../../../utils/toast_utils.dart';
import '../../../widgets/components/images.dart';

class ImageSection extends ConsumerStatefulWidget {
  final ProductData data;

  const ImageSection({
    super.key,
    required this.data,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ImageSectionState();
}

class _ImageSectionState extends ConsumerState<ImageSection> {
  late ProductData _product; // local, mutable via copyWith
  late String selectedImage;
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    _product = widget.data;
    selectedImage = _product.images.isNotEmpty
        ? _product.images.first
        : "assets/images/no_image_avail.png";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 35),
      child: Column(
        children: [
          // Top buttons row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Back Button
                BackBtn(
                  onTap: () => Navigator.of(context).pop(),
                  iconColor: Colors.red,
                ),

                // Wishlist Button (Immutable copyWith update)
                GestureDetector(
                  onTap: () async {
                    if (isProcessing) return;

                    setState(() => isProcessing = true);

                    final prevLiked = _product.isLiked;
                    // Optimistic UI update
                    setState(() {
                      _product = _product.copyWith(isLiked: !prevLiked);
                    });

                    try {
                      final res = await ref
                          .read(authRepositoryProvider.notifier)
                          .updateFav(_product.id);

                      final success = res.keys.first;
                      final message = res.values.first;

                      if (success) {
                        showSuccessMessage(message);
                      } else {
                        // revert if failed
                        setState(() {
                          _product = _product.copyWith(isLiked: prevLiked);
                        });
                        showErrorMessage(message);
                      }
                    } catch (e, st) {
                      log("updateFav error: $e\n$st");
                      // revert on exception
                      setState(() {
                        _product = _product.copyWith(isLiked: prevLiked);
                      });
                      showErrorMessage("Something went wrong");
                    } finally {
                      if (mounted) setState(() => isProcessing = false);
                    }
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.red.withOpacity(0.3),
                    radius: 19,
                    child: Icon(
                      _product.isLiked ? Icons.favorite : Icons.favorite_border,
                      color: Colors.red,
                      size: 26,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Image with gradient background
          Container(
            height: 400,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(16),
              ),
              gradient: LinearGradient(
                colors: [hexToColor("#FFC2C6"), hexToColor("#FFFFFF")],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              ),
            ),
            child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ImageViewerScreen(
                        images: _product.images,
                        initialImage: selectedImage,
                      ),
                    ),
                  );
                },
                child: Stack(
                  children: [
                    Hero(
                      tag: 'product-${_product.id}',
                      child: NetworkImageWidget(
                        selectedImage,
                        fit: BoxFit.contain,
                        height: 400,
                        width: double.infinity,
                      ),
                    ),

                    // SOLD OUT Overlay
                    // Stack के अंदर, Positioned widget को बदलें:

// SOLD OUT Badge - Bottom Center
                    if (_product.isSold == true)
                      Positioned(
                        bottom: 40,
                        left: 25,
                        right: 25,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          margin: const EdgeInsets.symmetric(horizontal: 40),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(0),
                          ),
                          child: const Text(
                            "SOLD OUT",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ),
                  ],
                )

                // child: Stack(
                //   children: [
                //     Hero(
                //       tag: 'product-${_product.id}',
                //       child: NetworkImageWidget(
                //         selectedImage,
                //         fit: BoxFit.contain,
                //         height: 400,
                //         width: double.infinity,
                //       ),
                //     ),
                //     Possition( Text("data")),
                //   ],
                // ),
                ),
          ),

          // Thumbnail carousel
          if (_product.images.length > 1)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: SizedBox(
                height: 54,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _product.images.map((e) {
                    final isSelected = e == selectedImage;
                    return GestureDetector(
                      onTap: () => setState(() => selectedImage = e),
                      child: AnimatedContainer(
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        duration: const Duration(milliseconds: 200),
                        padding: isSelected
                            ? const EdgeInsets.all(2)
                            : EdgeInsets.zero,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: isSelected
                              ? Border.all(color: Colors.redAccent, width: 2)
                              : null,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: NetworkImageWidget(
                            e,
                            height: 46,
                            width: 46,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
