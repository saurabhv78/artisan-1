import 'package:Artisan/src/models/artist_data/artist_data.dart';
import 'package:Artisan/src/routing/router.dart';
import 'package:Artisan/src/widgets/components/images.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constants/colors.dart';

class ArtistDetailSection extends ConsumerStatefulWidget {
  final ArtistInfo artistData;
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
              context.navigateTo(ArtistRoute(
                  artistData: ArtistInfo(id: widget.artistData.id)));
            },
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImageWidget(
                    widget.artistData.profilePicture ?? '',
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                  ).image,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.artistData.fullName ?? '',
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
                        "${widget.artistData.city ?? ""} , ${widget.artistData.country ?? ""}",
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
                // Image.asset(
                //   'assets/images/ic_chat2.png',
                //   height: 22.25,
                //   width: 22.25,
                // ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          if (widget.artistData.bio != null)
            // Text(
            //   widget.artistData.bio ?? '',
            //   style: GoogleFonts.nunitoSans(
            //     fontWeight: FontWeight.w400,
            //     color: grayTextColor,
            //     fontSize: 12,
            //     letterSpacing: .1,
            //   ),
            // ),
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (context) => DraggableScrollableSheet(
                    expand: false,
                    initialChildSize: 0.7,
                    minChildSize: 0.3,
                    maxChildSize: 0.95,
                    builder: (context, scrollController) {
                      return Column(
                        children: [
                          // Drag handle
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Container(
                              width: 40,
                              height: 5,
                              decoration: BoxDecoration(
                                color: Colors.grey[400],
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),

                          // Header with title & close button
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Bio",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close, size: 24),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ],
                            ),
                          ),

                          // Scrollable content
                          Expanded(
                            child: SingleChildScrollView(
                              controller: scrollController,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              child: Text(
                                widget.artistData.bio ?? '',
                                style: const TextStyle(
                                  fontSize: 15,
                                  height: 1.5,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                );
              },
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                  children: [
                    TextSpan(
                      text: widget.artistData.bio ?? '',
                      style: GoogleFonts.nunitoSans(
                        fontWeight: FontWeight.w400,
                        color: grayTextColor,
                        fontSize: 12,
                        letterSpacing: .1,
                      ),
                    ),
                    if (widget.artistData.bio!.length > 100)
                      const TextSpan(
                        text: " See more",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
      ),
    );
  }
}
