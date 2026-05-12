import 'dart:developer';

import 'package:Artisan/src/logic/repositories/auth_repository.dart';
import 'package:Artisan/src/routing/router.dart';
import 'package:Artisan/src/ui/home_tab/home_tab_page_model.dart';
import 'package:Artisan/src/ui/home_tab/widgets/trending_art_styles.dart';
import 'package:Artisan/src/utils/toast_utils.dart';
import 'package:Artisan/src/widgets/custom_scaffold.dart';
import 'package:Artisan/src/widgets/try_again_widget.dart';
import 'package:auto_route/auto_route.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
    getFcmToken();
  }

  Future<void> getFcmToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    log("FCM Token: $token");
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authRepositoryProvider, (prev, next) {
      if (next.status == AuthStatus.unauthenticated) {
        if (!(prev?.isGuest == true)) {
          showSuccessMessage("Logged Out Sucessfully!");
        }
        context.replaceRoute(const SignInRoute());
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
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 0.4, 0.7, 1.0],
            colors: [
              Color(0xFFFFFFFF), // White at top left
              Color(0xFFF4EBFF), // Soft violet
              Color(0xFFE0F7FA), // Soft cyan
              Color(0xFFE8EAF6), // Soft indigo
            ],
          ),
        ),
        child: SafeArea(
            child: CustomScaffold(
          topPadding: 0,
          bgColor: Colors.transparent,
          child: Column(children: [
            // --- PINNED HEADER ---
            Container(
              decoration: const BoxDecoration(
                color: Colors.transparent, // Allow gradient to show through
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 22),
                child: Column(
                  children: [
                    HomeAppBar(),
                    SizedBox(height: 15),
                    HomeSearchField(),
                    SizedBox(height: 15),
                  ],
                ),
              ),
            ),

            // --- SCROLLABLE CONTENT ---
            Expanded(
              child: RefreshIndicator(
                displacement: 20,
                edgeOffset: 0,
                onRefresh: () async {
                  await ref
                      .read(homeTabPageModelProvider.notifier)
                      .init(loading: false);
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
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
              ),
            ),
          ]),
        )),
      ),
    );
  }
}
