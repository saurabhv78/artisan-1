import 'dart:async';
import 'dart:ui';
import 'package:Artisan/src/logic/repositories/auth_repository.dart';
import 'package:Artisan/src/routing/router.dart';
import 'package:Artisan/src/widgets/components/images.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/discount_data/discount_data.dart';

class HomeDiscountSection extends ConsumerStatefulWidget {
  final List<DiscountData> data;
  const HomeDiscountSection({super.key, required this.data});

  @override
  ConsumerState<HomeDiscountSection> createState() =>
      _HomeDiscountSectionState();
}

class _HomeDiscountSectionState extends ConsumerState<HomeDiscountSection> {
  late final PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    final double initialWidth =
        WidgetsBinding.instance.window.physicalSize.width /
            WidgetsBinding.instance.window.devicePixelRatio;

    final isTablet = initialWidth >= 600;

    _pageController = PageController(
      viewportFraction: isTablet ? 0.70 : 0.92, // Slightly wider, looks natural
    );

    if (widget.data.isNotEmpty) {
      _timer = Timer.periodic(const Duration(seconds: 5), (_) {
        if (_pageController.hasClients) {
          _currentPage++;
          if (_currentPage >= widget.data.length) {
            _currentPage = 0;
          }

          if (_currentPage == 0) {
            _pageController.jumpToPage(_currentPage);
          } else {
            _pageController.animateToPage(
              _currentPage,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          }
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isGuest =
        ref.watch(authRepositoryProvider.select((value) => value.isGuest));

    if (widget.data.isEmpty) return const SizedBox.shrink();

    final width = MediaQuery.of(context).size.width;
    final isTablet = width >= 600;

    // Increased height to prevent clipping of shadows and give more breathing room
    final double sectionHeight = isTablet ? 320 : 190;

    return SizedBox(
      height: sectionHeight,
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              padEnds: false,
              itemCount: widget.data.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                final discount = widget.data[index];

                return GestureDetector(
                  onTap: isGuest
                      ? () => _showLoginPop(context, ref)
                      : () {
                          if (discount.id != null) {
                            context.navigateTo(
                              ProductListRoute(discountId: discount.id),
                            );
                          }
                        },
                  child: _DiscountCard(
                    data: discount,
                    isTablet: isTablet,
                  ),
                );
              },
            ),
          ),
          if (widget.data.length > 1)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.data.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 6,
                    width: _currentPage == index ? 20 : 6,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? Theme.of(context).primaryColor
                          : Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
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

class _DiscountCard extends StatelessWidget {
  final DiscountData data;
  final bool isTablet;

  const _DiscountCard({
    required this.data,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    final double borderRadius = isTablet ? 24 : 16;
    final double padding = isTablet ? 32 : 20;
    final double titleSize = isTablet ? 26 : 14;
    final double offerSize = isTablet ? 52 : 28;

    return Padding(
      // Added vertical padding to allow shadows to breathe without being cut
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 20 : 10,
        vertical: 10,
      ),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              offset: const Offset(0, 8),
              blurRadius: 16,
              spreadRadius: -4,
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Image
            NetworkImageWidget(
              data.discountImage.toString(),
              fit: BoxFit.fill,
            ),
            // Refined gradient targeting just the bottom-left corner
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.6),
                    Colors.black.withOpacity(0.15),
                    Colors.transparent,
                  ],
                  begin: Alignment.bottomLeft,
                  end: Alignment.center,
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
            if (data.isDiscountTextEnabled == true)
              Padding(
                padding: EdgeInsets.all(padding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${data.discountVal}% OFF",
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w900,
                        fontSize: offerSize,
                        color: Colors.white,
                        height: 1.1,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.4),
                            offset: const Offset(0, 4),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.4),
                              width: 0.5,
                            ),
                          ),
                          child: Text(
                            data.discountName.toString().toUpperCase(),
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.w700,
                              fontSize: titleSize * 0.7,
                              color: Colors.white,
                              letterSpacing: 1.2,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.3),
                                  offset: const Offset(0, 1),
                                  blurRadius: 2,
                                ),
                              ],
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
      ),
    );
  }
}
