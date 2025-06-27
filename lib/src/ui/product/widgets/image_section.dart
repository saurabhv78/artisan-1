import 'package:Artisan/src/constants/colors.dart';
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
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void initState() {
    selectedImage = "assets/images/no_image_avail.png";
    if (widget.data.images.isNotEmpty) selectedImage = widget.data.images.first;
    super.initState();
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
            NetworkImageWidget(
              selectedImage,
              fit: BoxFit.cover,
              height: 400,
              width: MediaQuery.sizeOf(context).width,
            ),
            Positioned(
              top: kToolbarHeight,
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
              top: kToolbarHeight,
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
            if (widget.data.images.length > 1)
              Positioned(
                bottom: 20,
                child: Container(
                  height: 54,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    // gradient: backgroundGradient,
                    color: Colors.grey.withOpacity(0.5),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: widget.data.images.map(
                      (e) {
                        final isSelected = e == selectedImage;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          child: GestureDetector(
                            onTap: () {
                              if (mounted) {
                                setState(() {
                                  selectedImage = e;
                                });
                              }
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: isSelected
                                    ? Border.all(
                                        color: Colors.blueAccent, width: 2)
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
                          ),
                        );
                      },
                    ).toList(),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
