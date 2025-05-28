import 'package:Artisan/src/models/artist_data/artist_data.dart';
import 'package:Artisan/src/routing/router.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constants/colors.dart';

class ArtistDetailSection extends ConsumerStatefulWidget {
  final ArtistData artistData;
  const ArtistDetailSection({
    super.key,
    required this.artistData,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ArtistDetailSectionState();
}

class _ArtistDetailSectionState extends ConsumerState<ArtistDetailSection> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Meet the Artist",
            style: GoogleFonts.nunitoSans(
              fontWeight: FontWeight.w400,
              color: bgDark,
              fontSize: 16,
              letterSpacing: -.1,
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              context.navigateTo(ArtistRoute(artistData: widget.artistData));
            },
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 25,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.artistData.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.nunitoSans(
                          fontWeight: FontWeight.w700,
                          color: bgDark,
                          fontSize: 16,
                          letterSpacing: .1,
                        ),
                      ),
                      Text(
                        widget.artistData.location,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.nunitoSans(
                          fontWeight: FontWeight.w400,
                          color: grayTextColor,
                          fontSize: 12,
                          letterSpacing: .1,
                        ),
                      ),
                    ],
                  ),
                ),
                Image.asset(
                  'assets/images/ic_chat2.png',
                  height: 22.25,
                  width: 22.25,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            widget.artistData.desc,
            style: GoogleFonts.nunitoSans(
              fontWeight: FontWeight.w400,
              color: grayTextColor,
              fontSize: 12,
              letterSpacing: .1,
            ),
          )
        ],
      ),
    );
  }
}
