import 'package:Artisan/src/constants/colors.dart';
import 'package:Artisan/src/ui/product/product_page_model.dart';
import 'package:Artisan/src/ui/product/widgets/product_view.dart';
import 'package:Artisan/src/utils/extensions.dart';
import 'package:auto_route/auto_route.dart';
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
  late String selectedImage;
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    selectedImage = widget.data.images.isNotEmpty
        ? widget.data.images.first
        : "assets/images/no_image_avail.png";
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      width: MediaQuery.sizeOf(context).width,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // Main image with tap to view full screen
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ImageViewerScreen(
                      images: widget.data.images,
                      initialImage: selectedImage,
                    ),
                  ),
                );
              },
              child: Hero(
                tag: 'product-${widget.data.id}',
                child: NetworkImageWidget(
                  selectedImage,
                  fit: BoxFit.contain, // Or BoxFit.scaleDown
                  height: 400,
                  width: MediaQuery.sizeOf(context).width,
                ),
              ),
            ),

            // Back Button
            Positioned(
              top: kToolbarHeight,
              left: 25,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Image.asset(
                  'assets/images/ic_back.png',
                  height: 38,
                  width: 38,
                ),
              ),
            ),

            // Wishlist Button
            // Wishlist Button
            Positioned(
              top: kToolbarHeight,
              right: 25,
              child: GestureDetector(
                onTap: () async {
                  if (isProcessing) return;
                  setState(() => isProcessing = true);

                  final res = await ref
                      .read(authRepositoryProvider.notifier)
                      .updateFav(widget.data.id);
                  final success = res.keys.first;
                  final message = res.values.first;

                  success
                      ? showSuccessMessage(message)
                      : showErrorMessage(message);

                  await ref.read(authRepositoryProvider.notifier).getWishlist();

                  if (mounted) setState(() => isProcessing = false);

                  // Fire-and-forget: no loading
                  ref
                      .read(productPageModelProvider.notifier)
                      .getProductData(widget.data.id);
                },
                child: CircleAvatar(
                  backgroundColor: Colors.white.withOpacity(0.7),
                  radius: 19,
                  child: Icon(
                    Icons.favorite,
                    color: widget.data.isLiked == true
                        ? Colors.red
                        : const Color(0xffC5C5C5),
                    size: 26,
                  ),
                ),
              ),
            ),

            // Thumbnail carousel
            if (widget.data.images.length > 1)
              Positioned(
                bottom: 20,
                child: Container(
                  height: 54,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black.withOpacity(0.4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: widget.data.images.map((e) {
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
      ),
    );
  }
}
