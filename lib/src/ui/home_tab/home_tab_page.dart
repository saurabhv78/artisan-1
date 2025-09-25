import 'package:Artisan/src/logic/repositories/auth_repository.dart';
import 'package:Artisan/src/routing/router.dart';
import 'package:Artisan/src/ui/home_tab/home_tab_page_model.dart';
import 'package:Artisan/src/ui/home_tab/widgets/trending_art_styles.dart';
import 'package:Artisan/src/utils/toast_utils.dart';
import 'package:Artisan/src/widgets/custom_scaffold.dart';
import 'package:Artisan/src/widgets/try_again_widget.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'widgets/widgets.dart';

@RoutePage()
class HomeTabPage extends ConsumerStatefulWidget {
  const HomeTabPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends ConsumerState<HomeTabPage> {
  late DateTime time;
  double opacity = 0;
  @override
  void initState() {
    super.initState();
    time = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authRepositoryProvider, (prev, next) {
      if (next.status == AuthStatus.unauthenticated) {
        showSuccessMessage("Logged Out Sucessfully!");
        context.replaceRoute(const WelcomeRoute());
      }
    });

    ref.listen(homeTabPageModelProvider, (prev, next) async {
      if (next.status == HomePageStatus.loaded) {
        await Future.delayed(const Duration(milliseconds: 400));
        opacity = 1;
        if (mounted) setState(() {});
      } else {
        await Future.delayed(const Duration(milliseconds: 400));
        opacity = 0;
        if (mounted) setState(() {});
      }
    });
    final categoryData = ref
        .watch(homeTabPageModelProvider.select((value) => value.categoryData));
    final discountData = ref
        .watch(homeTabPageModelProvider.select((value) => value.discountData));
    final featuredProducts = ref.watch(
        homeTabPageModelProvider.select((value) => value.featuredProducts));
    final trendingArtists = ref.watch(
          homeTabPageModelProvider.select((value) => value.trendingArtStyles),
        ) ??
        [];
    final status =
        ref.watch(homeTabPageModelProvider.select((value) => value.status));

    return WillPopScope(
      onWillPop: () async {
        if (context.tabsRouter.activeIndex == 0) {
          final currentTime = DateTime.now();
          if (currentTime.difference(time).inSeconds <= 2) {
            return true;
          } else {
            showSuccessMessage('Press back again to exit');
            time = DateTime.now();
          }
        } else {
          FocusScope.of(context).unfocus();
          context.tabsRouter.setActiveIndex(0);
        }

        return false;
      },
      child: CustomScaffold(
          topPadding: 35,
          bgColor: Colors.white,
          child: RefreshIndicator(
            displacement: 60,
            edgeOffset: 120,
            onRefresh: () async {
              await ref
                  .read(homeTabPageModelProvider.notifier)
                  .init(loading: false);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 22),
                      child: Column(
                        children: [
                          // SizedBox(height: 15),
                          HomeAppBar(),
                          SizedBox(height: 15),
                          HomeSearchField(),
                          SizedBox(height: 15),
                        ],
                      ),
                    ),
                  ),
                  if (status == HomePageStatus.loaded &&
                      categoryData != null) ...[
                    AnimatedOpacity(
                      key: ValueKey(opacity),
                      opacity: opacity,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          HomeCategorySection(data: categoryData),
                          const SizedBox(height: 10),
                          if ((discountData ?? []).isNotEmpty) ...[
                            HomeDiscountSection(data: discountData ?? []),
                            const SizedBox(height: 25),
                          ],
                          FeaturedSection(data: featuredProducts ?? []),
                          const SizedBox(height: 20),
                          const TrendingArtistSection(),
                          const SizedBox(height: 20),
                          TrendingArtStylesSection(
                              trendingArtists: trendingArtists),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ] else ...[
                    TryAgainWidget(
                      onTap: () {
                        ref.read(homeTabPageModelProvider.notifier).init();
                      },
                      isProcessing: status == HomePageStatus.initial ||
                          status == HomePageStatus.loading,
                      errMessage: ref.watch(
                        homeTabPageModelProvider.select(
                          (value) => value.errorMessage.trim().isEmpty
                              ? "Something Went Wrong!!!"
                              : value.errorMessage.trim(),
                        ),
                      ),
                    )
                  ]
                ],
              ),
            ),
          )),
    );
  }
}
