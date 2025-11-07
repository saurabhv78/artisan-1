import 'package:Artisan/src/widgets/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:Artisan/src/widgets/components/images.dart';

class ImageViewerScreen extends StatefulWidget {
  final List<String> images;
  final String initialImage;

  const ImageViewerScreen({
    super.key,
    required this.images,
    required this.initialImage,
  });

  @override
  State<ImageViewerScreen> createState() => _ImageViewerScreenState();
}

class _ImageViewerScreenState extends State<ImageViewerScreen> {
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.images.indexOf(widget.initialImage);
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      bgColor: const Color(0xffEFE4FF),
      // backgroundColor: Colors.black,
      child: SafeArea(
        child: Stack(
          children: [
            // Photo Gallery
            PhotoViewGallery.builder(
              itemCount: widget.images.length,
              pageController: PageController(initialPage: selectedIndex),
              onPageChanged: (index) {
                setState(() {
                  selectedIndex = index;
                });
              },
              builder: (context, index) {
                return PhotoViewGalleryPageOptions(
                  imageProvider: NetworkImage(widget.images[index]),
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered * 3,
                  heroAttributes:
                      PhotoViewHeroAttributes(tag: widget.images[index]),
                );
              },
              scrollPhysics: const BouncingScrollPhysics(),
              backgroundDecoration: const BoxDecoration(color: Colors.black),
            ),

            // Back Button
            Positioned(
              top: 10,
              left: 10,
              child: CircleAvatar(
                backgroundColor: Colors.white.withOpacity(0.8),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),

            // Thumbnails
            if (widget.images.length > 1)
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Container(
                  height: 64,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.images.length,
                    itemBuilder: (context, index) {
                      final image = widget.images[index];
                      final isSelected = selectedIndex == index;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          padding: isSelected ? const EdgeInsets.all(2) : null,
                          decoration: BoxDecoration(
                            border: isSelected
                                ? Border.all(color: Colors.redAccent, width: 2)
                                : null,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: NetworkImageWidget(
                              image,
                              height: 50,
                              width: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
