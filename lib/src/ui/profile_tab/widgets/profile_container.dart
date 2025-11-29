// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'package:google_fonts/google_fonts.dart';

// import '../../../constants/colors.dart';

// class ProfileContainer extends ConsumerWidget {
//   final String title;
//   final String subtitle;
//   final IconData icon;

//   final VoidCallback? onTap;
//   const ProfileContainer({
//     super.key,
//     required this.subtitle,
//     required this.title,
//     required this.icon,
//     this.onTap,
//   });

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return GestureDetector(
//       behavior: HitTestBehavior.opaque,
//       onTap: onTap,
//       child: Row(
//         children: [
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   maxLines: 1,
//                   style: GoogleFonts.nunitoSans(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w400,
//                   ),
//                 ),
//                 Text(
//                   subtitle,
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                   style: GoogleFonts.nunitoSans(
//                     fontSize: 14,
//                     color: Color(0xff8F98AA),
//                     fontWeight: FontWeight.w400,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(width: 10),
//           Icon(icon, color: primaryColor, size: 25)
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants/colors.dart';

class ProfileContainer extends ConsumerWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback? onTap;

  const ProfileContainer({
    super.key,
    required this.subtitle,
    required this.title,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.sizeOf(context).width;

    // Responsive sizes
    final titleFont = width < 600 ? 16.0 : 18.0;
    final subtitleFont = width < 600 ? 14.0 : 16.0;
    final iconSize = width < 600 ? 25.0 : 30.0;
    final verticalPadding = width < 600 ? 6.0 : 12.0;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: verticalPadding),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// TEXT SECTION
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    style: GoogleFonts.nunitoSans(
                      fontSize: titleFont,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.nunitoSans(
                      fontSize: subtitleFont,
                      color: const Color(0xff8F98AA),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            /// ICON SECTION
            Icon(
              icon,
              color: primaryColor,
              size: iconSize,
            )
          ],
        ),
      ),
    );
  }
}
