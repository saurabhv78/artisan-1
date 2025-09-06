import 'package:Artisan/src/models/artist_data/artist_data.dart';
import 'package:Artisan/src/routing/router.dart';
import 'package:Artisan/src/widgets/components/images.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constants/colors.dart';

class TrendingArtistListCard extends ConsumerWidget {
  final ArtistData data;
  final int index;
  const TrendingArtistListCard({
    super.key,
    required this.data,
    required this.index,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 226,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SizedBox(
            height: 210,
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
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        NetworkImageWidget(
                          data.images.isNotEmpty ? data.images[0] : '',
                          fit: BoxFit.cover,
                          width: MediaQuery.sizeOf(context).width,
                          height: 190,
                        ),
                        // Image.asset(
                        //   'assets/images/category${index + 1}.png',
                        //   fit: BoxFit.cover,
                        //   height: 200,
                        //   width: MediaQuery.sizeOf(context).width,
                        // ),
                        Container(
                          height: 180,
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
                            child: Center(
                              child: Text(
                                data.name ?? "",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.nunitoSans(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
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
                          data.artist?.fullName?.toString() ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.nunitoSans(
                            fontSize: 12,
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
          Positioned(
            top: 0,
            child: InkWell(
              onTap: () {
                context.navigateTo(
                    ArtistRoute(artistData: ArtistInfo(id: data.artist?.id)));
              },
              child: CircleAvatar(
                radius: 35,
                backgroundColor: primaryColor,
                backgroundImage: (data.artist?.profilePicture ?? '').isNotEmpty
                    ? NetworkImageWidget(
                        data.artist!.profilePicture ?? '',
                        fit: BoxFit.cover,
                        width: MediaQuery.sizeOf(context).width,
                        height: 212,
                      ).image
                    : null,
                child: (data.artist?.profilePicture ?? '').isEmpty
                    ? const Icon(Icons.person, size: 20, color: Colors.white)
                    : null,
                // fit: BoxFit.cover,
                // image: 'https://picsum.photos/200/300?random=$index',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
