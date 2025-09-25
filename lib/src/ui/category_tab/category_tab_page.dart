import 'package:Artisan/src/constants/colors.dart';

import 'package:Artisan/src/logic/repositories/auth_repository.dart';

import 'package:Artisan/src/ui/category_tab/category_tab_page_model.dart';
import 'package:Artisan/src/ui/category_tab/widgets/category_list.dart';
import 'package:Artisan/src/widgets/custom_scaffold.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:google_fonts/google_fonts.dart';

import '../../routing/router.dart';
import 'widgets/product_list.dart';

@RoutePage()
class CategoryTabPage extends ConsumerStatefulWidget {
  const CategoryTabPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CategoryTabPageState();
}

class _CategoryTabPageState extends ConsumerState<CategoryTabPage>
    with TickerProviderStateMixin {
  late final TabController? _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(categoryTabPageModelProvider, (prev, next) {});
    final wishlist =
        ref.watch(authRepositoryProvider.select((value) => value.wishlist));
    final cartData =
        ref.watch(authRepositoryProvider.select((value) => value.cartData));

    // if (mounted) {
    //   setState(() {});
    // }
    return CustomScaffold(
        topPadding: 35,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          context.pushRoute(const WishlistRoute());
                        },
                        child: Stack(
                          children: [
                            Image.asset(
                              'assets/images/ic_heart.png',
                              height: 26,
                              width: 30,
                            ),
                            if (wishlist.isNotEmpty)
                              Positioned(
                                right: 0,
                                top: 0,
                                child: Container(
                                  height: 16,
                                  width: 16,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: primaryColor,
                                  ),
                                  child: Center(
                                    child: Text(
                                      wishlist.length > 99
                                          ? "99"
                                          : wishlist.length.toString(),
                                      style: GoogleFonts.nunitoSans(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 13,
                      ),
                      GestureDetector(
                        onTap: () {
                          context.pushRoute(const CartRoute());
                        },
                        child: Stack(
                          children: [
                            Image.asset(
                              'assets/images/ic_cart.png',
                              height: 26,
                              width: 30,
                            ),
                            if (cartData.isNotEmpty)
                              Positioned(
                                right: 0,
                                top: 0,
                                child: Container(
                                  height: 16,
                                  width: 16,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: primaryColor,
                                  ),
                                  child: Center(
                                    child: Text(
                                      cartData.length > 99
                                          ? "99"
                                          : cartData.length.toString(),
                                      style: GoogleFonts.nunitoSans(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Center(
                    child: Text(
                      "Explore",
                      style: GoogleFonts.nunitoSans(
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  TabBar(
                    controller: _tabController,
                    indicatorColor: primaryColor,
                    dividerColor: Colors.transparent,
                    overlayColor: MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                      return states.contains(MaterialState.focused)
                          ? null
                          : Colors.transparent;
                    }),
                    tabs: [
                      Tab(
                        height: 40,
                        child: Text(
                          "CATEGORIES",
                          style: GoogleFonts.nunitoSans(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Tab(
                        height: 40,
                        child: Text(
                          "PRODUCTS",
                          style: GoogleFonts.nunitoSans(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 34,
                    child: VerticalDivider(
                      color: Colors.black,
                      thickness: 1,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    RefreshIndicator(
                        onRefresh: () async {
                          ref
                              .read(categoryTabPageModelProvider.notifier)
                              .refreshCount();
                          await Future.delayed(
                              const Duration(milliseconds: 300));
                        },
                        child: const CategoryListSection()),
                    RefreshIndicator(
                      onRefresh: () async {
                        ref
                            .read(categoryTabPageModelProvider.notifier)
                            .refreshCount();
                        await Future.delayed(const Duration(milliseconds: 300));
                      },
                      child: const ProductListSection(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
