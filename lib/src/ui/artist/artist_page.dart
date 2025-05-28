import 'package:Artisan/src/ui/artist/artist_page_model.dart';
import 'package:Artisan/src/ui/artist/widgets/popular_products_section.dart';
import 'package:Artisan/src/ui/auth/widgets/back_btn.dart';
import 'package:Artisan/src/widgets/custom_scaffold.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/artist_data/artist_data.dart';
import '../../widgets/try_again_widget.dart';

@RoutePage()
class ArtistPage extends ConsumerStatefulWidget {
  final ArtistData artistData;
  const ArtistPage({
    super.key,
    required this.artistData,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ArtistPageState();
}

class _ArtistPageState extends ConsumerState<ArtistPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await ref
          .read(artistPageModelProvider.notifier)
          .getPopularProducts(widget.artistData.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(artistPageModelProvider, (prev, next) {});
    final status =
        ref.watch(artistPageModelProvider.select((value) => value.status));
    final popularProducts = ref.watch(
        artistPageModelProvider.select((value) => value.popularProducts));
    return CustomScaffold(
        child: status == ArtistPageStatus.loaded && popularProducts != null
            ? SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 234,
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.asset(
                              'assets/images/ic_product1.png',
                              height: 200,
                              width: MediaQuery.sizeOf(context).width,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color.fromRGBO(0, 0, 0, .22),
                                  Color.fromRGBO(0, 0, 0, .22),
                                ],
                              ),
                            ),
                            height: 200,
                            width: MediaQuery.sizeOf(context).width,
                          ),
                          Positioned(
                            top: 10,
                            left: 22,
                            child: BackBtn(
                                iconColor: Colors.white,
                                onTap: () {
                                  context.maybePop();
                                }),
                          ),
                          const Positioned(
                            left: 22,
                            bottom: 0,
                            child: CircleAvatar(
                              radius: 37,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            widget.artistData.name,
                            maxLines: 2,
                            style: GoogleFonts.nunitoSans(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            widget.artistData.desc,
                            // maxLines: 2,
                            style: GoogleFonts.nunitoSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          PopularProductsSection(data: popularProducts),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : TryAgainWidget(
                onTap: () {
                  ref
                      .read(artistPageModelProvider.notifier)
                      .getPopularProducts(widget.artistData.id);
                },
                isProcessing: status == ArtistPageStatus.initial ||
                    status == ArtistPageStatus.loading,
                errMessage: ref.watch(
                  artistPageModelProvider.select(
                    (value) => value.errorMessage.trim().isEmpty
                        ? "Something Went Wrong!!!"
                        : value.errorMessage.trim(),
                  ),
                ),
              ));
  }
}
