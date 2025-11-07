import 'dart:async';
import 'package:Artisan/src/routing/router.dart';
import 'package:Artisan/src/widgets/components/images.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/discount_data/discount_data.dart';

class HomeDiscountSection extends StatefulWidget {
  final List<DiscountData> data;
  const HomeDiscountSection({super.key, required this.data});

  @override
  State<HomeDiscountSection> createState() => _HomeDiscountSectionState();
}

class _HomeDiscountSectionState extends State<HomeDiscountSection> {
  late final PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController =
        PageController(viewportFraction: 0.9); // show partial next
    if (widget.data.isNotEmpty) {
      _timer = Timer.periodic(const Duration(seconds: 3), (_) {
        if (_pageController.hasClients) {
          _currentPage++;
          if (_currentPage >= widget.data.length) {
            _currentPage = 0;
          }
          _pageController.animateToPage(
            _currentPage,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
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
    if (widget.data.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 150,
      child: PageView.builder(
        controller: _pageController,
        itemCount: widget.data.length,
        itemBuilder: (context, index) {
          final discount = widget.data[index];
          return GestureDetector(
            onTap: () {
              context.navigateTo(ProductListRoute(discountId: discount.id));
            },
            child: _DiscountCard(data: discount),
          );
        },
      ),
    );
  }
}

class _DiscountCard extends StatelessWidget {
  final DiscountData data;
  const _DiscountCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xff141516),
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.25),
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
                      Colors.black.withOpacity(0.7),
                      Colors.black.withOpacity(0.0),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.center,
                  ),
                ),
              ),
              if (data.isDiscountTextEnabled == true)
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "UPTO",
                        style: GoogleFonts.nunitoSans(
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "${data.discountVal}% OFF",
                        style: GoogleFonts.nunitoSans(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        data.discountName.toString(),
                        style: GoogleFonts.nunitoSans(
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
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
