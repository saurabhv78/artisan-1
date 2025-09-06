import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/* class NetworkImageWidget extends Image {
  NetworkImageWidget({
    Key? key,
    required String image,
    double? height,
    double? width,
    BoxFit fit = BoxFit.cover,
  }) : super.network(
          image,
          key: key,
          height: height ?? 150,
          width: width ?? double.infinity,
          fit: fit,
          errorBuilder: _errorBuilder,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return SizedBox(
              height: height ?? 150,
              width: width ?? double.infinity,
              child: Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          (loadingProgress.expectedTotalBytes ?? 1)
                      : null,
                ),
              ),
            );
          },
        );

  static Widget _errorBuilder(
      BuildContext context, Object error, StackTrace? stackTrace) {
    return Container(
      height: this.height ?? 150,
      width: width ?? double.infinity,
      color: Colors.grey.shade200,
      child: Center(
        child: Text(
          'Image not available',
          style: GoogleFonts.nunitoSans(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.grey.shade600,
          ),
        ),
      ),
    );
  }
}
 */
class NetworkImageWidget extends Image {
  NetworkImageWidget(
    String image, {
    super.key,
    double? height,
    double? width,
    BoxFit super.fit = BoxFit.cover,
  }) : super(
          image: _resolveProvider(image),
          height: height ?? 150,
          width: width ?? double.infinity,
          errorBuilder: (context, error, stackTrace) =>
              _errorPlaceholder(height ?? 150, width ?? double.infinity),
          loadingBuilder: (context, child, loadingProgress) {
            if (image.startsWith('assets/')) {
              return child;
            }
            if (loadingProgress == null) return child;
            return SizedBox(
              height: height ?? 150,
              width: width ?? double.infinity,
              child: Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          (loadingProgress.expectedTotalBytes ?? 1)
                      : null,
                ),
              ),
            );
          },
        );

  static ImageProvider<Object> _resolveProvider(String image) {
    return image.startsWith('assets/')
        ? AssetImage(image)
        : NetworkImage(image) as ImageProvider<Object>;
  }

  static Widget _errorPlaceholder(double height, double width) {
    return Container(
      height: height,
      width: width,
      color: Colors.grey.shade200,
      child: Center(
        child: Text(
          'Image not available',
          style: GoogleFonts.nunitoSans(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.grey.shade600,
          ),
        ),
      ),
    );
  }
}
