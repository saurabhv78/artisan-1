import 'package:Artisan/src/models/artist_data/artist_data.dart';
import 'package:Artisan/src/widgets/components/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/colors.dart';
import '../models/product_data/product_data.dart';

class TrendingArtStyleCard extends ConsumerWidget {
  final ArtistData data;
  final int index;
  const TrendingArtStyleCard({
    super.key,
    required this.data,
    required this.index,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 243,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SizedBox(
            height: 212,
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
                          fit: BoxFit.cover,
                          width: MediaQuery.sizeOf(context).width,
                          height: 212,
                          image: data.images.isNotEmpty ? data.images[0] : '',
                          // Image.asset(
                          //   'assets/images/category${index + 1}.png',
                          //   fit: BoxFit.cover,
                          //   width: MediaQuery.sizeOf(context).width,
                          //   height: 212,
                        ),
                        Container(
                          height: 200,
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
                                data.name.toString(),
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
                  ],
                ),
              ),
            ),
          ),
          // Positioned(
          //   top: 0,
          //   child: CircleAvatar(
          //     radius: 28,
          //     backgroundColor: primaryColor,
          //     backgroundImage: NetworkImageWidget(
          //       fit: BoxFit.cover,
          //       width: MediaQuery.sizeOf(context).width,
          //       height: 212,
          //       image: data.artist.profilePicture ?? '',
          //     ).image,
          //   ),
          // )
        ],
      ),
    );
  }
}
