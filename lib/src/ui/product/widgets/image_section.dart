import 'package:Artisan/src/constants/colors.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../logic/repositories/auth_repository.dart';
import '../../../models/product_data/product_data.dart';
import '../../../utils/toast_utils.dart';

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
  String selectedImage = "assets/images/img_product.png";
  bool isProcessing = false;
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
            Image.asset(
              selectedImage,
              fit: BoxFit.cover,
              height: 400,
              width: MediaQuery.sizeOf(context).width,
            ),
            Positioned(
              top: 15,
              left: 25,
              child: GestureDetector(
                onTap: () => context.maybePop(),
                child: Image.asset(
                  'assets/images/ic_back.png',
                  height: 38,
                  width: 38,
                ),
              ),
            ),
            Positioned(
              top: 15,
              right: 25,
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
                        .updateFav(widget.data.id);
                    if (res.keys.first != true) {
                      showErrorMessage(res.values.first);
                    } else {
                      showSuccessMessage(res.values.first);
                      ref.read(authRepositoryProvider.notifier).getWishlist();
                    }
                    if (mounted) {
                      setState(() {
                        isProcessing = false;
                      });
                    }
                  }
                },
                child: CircleAvatar(
                  backgroundColor: Colors.white.withOpacity(0.7),
                  radius: 19,
                  child: Icon(
                    Icons.favorite,
                    color: ref.watch(authRepositoryProvider.select((value) =>
                                value.wishlist.indexWhere(
                                    (element) => element == widget.data.id))) !=
                            -1
                        ? Colors.red
                        : const Color(0xffC5C5C5),
                    size: 26,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              child: Stack(
                children: [
                  Container(
                    height: 54,
                    width: 162,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  Container(
                    height: 54,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      gradient: backgroundGradient,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 4,
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: GestureDetector(
                              onTap: () {
                                if (mounted) {
                                  setState(() {
                                    selectedImage =
                                        "assets/images/img_product.png";
                                  });
                                }
                              },
                              child: Image.asset(
                                'assets/images/img_product.png',
                                height: 46,
                                width: 46,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: GestureDetector(
                              onTap: () {
                                if (mounted) {
                                  setState(() {
                                    selectedImage =
                                        "assets/images/ic_product2.png";
                                  });
                                }
                              },
                              child: Image.asset(
                                'assets/images/ic_product2.png',
                                height: 46,
                                width: 46,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: GestureDetector(
                              onTap: () {
                                if (mounted) {
                                  setState(() {
                                    selectedImage =
                                        "assets/images/ic_product1.png";
                                  });
                                }
                              },
                              child: Image.asset(
                                'assets/images/ic_product1.png',
                                height: 46,
                                width: 46,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
