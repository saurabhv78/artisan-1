// import 'package:Artisan/src/models/artist_data/artist_data.dart';
// import 'package:Artisan/src/routing/router.dart';
// import 'package:Artisan/src/widgets/components/images.dart';
// import 'package:auto_route/auto_route.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'package:google_fonts/google_fonts.dart';

// import '../constants/colors.dart';

// class TrendingArtistsCard extends ConsumerWidget {
//   final ArtistData data;
//   final int index;
//   const TrendingArtistsCard({
//     super.key,
//     required this.data,
//     required this.index,
//   });

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return SizedBox(
//       height: 243,
//       child: Stack(
//         alignment: Alignment.bottomCenter,
//         children: [
//           SizedBox(
//             height: 227,
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(8),
//               child: Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(8),
//                   color: Colors.white,
//                   boxShadow: const [
//                     BoxShadow(
//                       color: Color.fromRGBO(0, 0, 0, 0.25),
//                       offset: Offset(1, 2),
//                       blurRadius: 4,
//                     )
//                   ],
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     Stack(
//                       alignment: Alignment.bottomCenter,
//                       children: [
//                         NetworkImageWidget(
//                           data.images.isNotEmpty ? data.images[0] : '',
//                           fit: BoxFit.cover,
//                           width: MediaQuery.sizeOf(context).width,
//                           height: 200,
//                           // Image.asset(
//                           //   'assets/images/category${index + 1}.png',
//                           //   fit: BoxFit.cover,
//                           //   width: MediaQuery.sizeOf(context).width,
//                           //   height: 212,
//                         ),
//                         Container(
//                           height: 200,
//                           decoration: const BoxDecoration(
//                             gradient: LinearGradient(
//                               begin: Alignment.topCenter,
//                               end: Alignment.bottomCenter,
//                               colors: [
//                                 Color.fromRGBO(0, 0, 0, 0),
//                                 Color.fromRGBO(0, 0, 0, .6),
//                               ],
//                             ),
//                           ),
//                         ),
//                         Positioned(
//                           bottom: 10,
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 5),
//                             child: Center(
//                               child: Text(
//                                 data.name.toString(),
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                                 style: GoogleFonts.nunitoSans(
//                                   fontSize: 12,
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.w700,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(
//                       height: 20,
//                       child: Center(
//                         child: Text(
//                           data.artist?.fullName?.toString() ?? '',
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                           style: GoogleFonts.nunitoSans(
//                             fontSize: 12,
//                             color: Colors.black,
//                             fontWeight: FontWeight.w700,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             top: 0,
//             child: GestureDetector(
//               onTap: () {
//                 context.navigateTo(
//                     ArtistRoute(artistData: ArtistInfo(id: data.artist?.id)));

//                 // context
//                 //     .navigateTo(ArtistRoute(artistData: data.toArtistInfo()));
//               },
//               child: CircleAvatar(
//                 radius: 35,
//                 backgroundColor: primaryColor,
//                 backgroundImage: NetworkImageWidget(
//                   data.artist?.profilePicture ?? '',
//                   fit: BoxFit.cover,
//                   width: MediaQuery.sizeOf(context).width,
//                   height: 212,
//                 ).image,
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
import 'package:Artisan/src/logic/repositories/auth_repository.dart';
import 'package:Artisan/src/models/artist_data/artist_data.dart';
import 'package:Artisan/src/routing/router.dart';
import 'package:Artisan/src/widgets/components/images.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/colors.dart';

class TrendingArtistsCard extends ConsumerWidget {
  final ArtistData data;
  final int index;

  const TrendingArtistsCard({
    super.key,
    required this.data,
    required this.index,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;
    final isTablet = width >= 600;

    final isGuest =
        ref.watch(authRepositoryProvider.select((value) => value.isGuest));
    // Scale values proportionally
    final double cardHeight = isTablet ? 320 : 243;
    final double imageHeight = isTablet ? 270 : 200;
    final double avatarRadius = isTablet ? 45 : 35;
    final double nameFont = isTablet ? 16 : 12;
    final double fullNameFont = isTablet ? 16 : 12;

    return SizedBox(
      height: cardHeight,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SizedBox(
            height: cardHeight - 20,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.25),
                      offset: Offset(1, 2),
                      blurRadius: 4,
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Artist image with gradient
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        SizedBox(
                          height: imageHeight,
                          width: double.infinity,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(8),
                            ),
                            child: NetworkImageWidget(
                              data.images.isNotEmpty ? data.images[0] : '',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                        ),
                        Container(
                          height: imageHeight,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color.fromRGBO(0, 0, 0, 0),
                                Color.fromRGBO(0, 0, 0, .6),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Text(
                              data.name ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.nunitoSans(
                                fontSize: nameFont,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                      child: Center(
                        child: Text(
                          data.artist?.fullName ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.nunitoSans(
                            fontSize: fullNameFont,
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Circle Avatar
          Positioned(
            top: 0,
            child: GestureDetector(
              onTap: isGuest
                  ? () => _showLoginPop(context, ref)
                  : () {
                      context.navigateTo(
                        ArtistRoute(
                            artistData: ArtistInfo(id: data.artist?.id)),
                      );
                    },
              child: CircleAvatar(
                radius: avatarRadius,
                backgroundColor: primaryColor,
                backgroundImage: NetworkImageWidget(
                  data.artist?.profilePicture ?? '',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ).image,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLoginPop(BuildContext context, WidgetRef ref) =>
      ref.read(authRepositoryProvider.notifier).showLoginPopUp(context);
}
