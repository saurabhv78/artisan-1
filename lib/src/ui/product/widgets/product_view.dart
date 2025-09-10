import 'package:Artisan/src/constants/colors.dart';
import 'package:Artisan/src/widgets/components/images.dart';
import 'package:Artisan/src/widgets/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:photo_view/photo_view.dart';

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
  late String selectedImage;

  @override
  void initState() {
    super.initState();
    selectedImage = widget.initialImage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Center(
            //   child: PhotoView(
            //     imageProvider: NetworkImage(selectedImage),
            //     backgroundDecoration: const BoxDecoration(color: Colors.black),
            //     minScale: PhotoViewComputedScale.contained,
            //     maxScale: PhotoViewComputedScale.covered * 2.0,
            //   ),
            // ),

            // Back button
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
                      final isSelected = selectedImage == image;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedImage = image;
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
