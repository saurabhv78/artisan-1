// import 'dart:async';
// import 'package:Artisan/src/routing/router.dart';
// import 'package:Artisan/src/widgets/components/images.dart';
// import 'package:auto_route/auto_route.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../../../models/discount_data/discount_data.dart';

// class HomeDiscountSection extends StatefulWidget {
//   final List<DiscountData> data;
//   const HomeDiscountSection({super.key, required this.data});

//   @override
//   State<HomeDiscountSection> createState() => _HomeDiscountSectionState();
// }

// class _HomeDiscountSectionState extends State<HomeDiscountSection> {
//   late final PageController _pageController;
//   int _currentPage = 0;
//   Timer? _timer;

//   @override
//   void initState() {
//     super.initState();
//     _pageController =
//         PageController(viewportFraction: 0.9); // show partial next
//     if (widget.data.isNotEmpty) {
//       _timer = Timer.periodic(const Duration(seconds: 3), (_) {
//         if (_pageController.hasClients) {
//           _currentPage++;
//           if (_currentPage >= widget.data.length) {
//             _currentPage = 0;
//           }
//           _pageController.animateToPage(
//             _currentPage,
//             duration: const Duration(milliseconds: 500),
//             curve: Curves.easeInOut,
//           );
//         }
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     _pageController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (widget.data.isEmpty) return const SizedBox.shrink();

//     return SizedBox(
//       height: 150,
//       child: PageView.builder(
//         controller: _pageController,
//         itemCount: widget.data.length,
//         itemBuilder: (context, index) {
//           final discount = widget.data[index];
//           return GestureDetector(
//             onTap: () {
//               context.navigateTo(ProductListRoute(discountId: discount.id));
//             },
//             child: _DiscountCard(data: discount),
//           );
//         },
//       ),
//     );
//   }
// }

// class _DiscountCard extends StatelessWidget {
//   final DiscountData data;
//   const _DiscountCard({super.key, required this.data});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 6),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(12),
//         child: Container(
//           decoration: BoxDecoration(
//             color: const Color(0xff141516),
//             borderRadius: BorderRadius.circular(12),
//             boxShadow: const [
//               BoxShadow(
//                 color: Color.fromRGBO(0, 0, 0, 0.25),
//                 offset: Offset(1, 2),
//                 blurRadius: 4,
//               ),
//             ],
//           ),
//           child: Stack(
//             fit: StackFit.expand,
//             children: [
//               NetworkImageWidget(
//                 data.discountImage.toString(),
//                 fit: BoxFit.cover,
//               ),
//               Container(
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [
//                       Colors.black.withOpacity(0.7),
//                       Colors.black.withOpacity(0.0),
//                     ],
//                     begin: Alignment.centerLeft,
//                     end: Alignment.center,
//                   ),
//                 ),
//               ),
//               if (data.isDiscountTextEnabled == true)
//                 Padding(
//                   padding: const EdgeInsets.all(12.0),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "UPTO",
//                         style: GoogleFonts.nunitoSans(
//                           fontWeight: FontWeight.w400,
//                           fontSize: 15,
//                           color: Colors.white,
//                         ),
//                       ),
//                       Text(
//                         "${data.discountVal}% OFF",
//                         style: GoogleFonts.nunitoSans(
//                           fontWeight: FontWeight.w700,
//                           fontSize: 20,
//                           color: Colors.white,
//                         ),
//                       ),
//                       Text(
//                         data.discountName.toString(),
//                         style: GoogleFonts.nunitoSans(
//                           fontWeight: FontWeight.w400,
//                           fontSize: 15,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'dart:async';
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

    final double sectionHeight = isTablet ? 300 : 170;

    return SizedBox(
      height: sectionHeight,
      child: PageView.builder(
        controller: _pageController,
        padEnds: false, // FIX: स्लाइड अब center पर नहीं आएगी
        itemCount: widget.data.length,
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
    final double borderRadius = isTablet ? 20 : 14;
    final double padding = isTablet ? 28 : 16;
    final double titleSize = isTablet ? 24 : 16;
    final double offerSize = isTablet ? 44 : 22;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isTablet ? 25 : 15),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(1, 2),
                blurRadius: 4,
              ),
            ],
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              NetworkImageWidget(
                data.discountImage.toString(),
                fit: BoxFit.cover,
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.75),
                      Colors.black.withOpacity(0.0),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.center,
                  ),
                ),
              ),
              if (data.isDiscountTextEnabled == true)
                Padding(
                  padding: EdgeInsets.all(padding),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "UPTO",
                        style: GoogleFonts.nunitoSans(
                          fontWeight: FontWeight.w400,
                          fontSize: titleSize,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "${data.discountVal}% OFF",
                        style: GoogleFonts.nunitoSans(
                          fontWeight: FontWeight.w800,
                          fontSize: offerSize,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        data.discountName.toString(),
                        style: GoogleFonts.nunitoSans(
                          fontWeight: FontWeight.w400,
                          fontSize: titleSize,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
