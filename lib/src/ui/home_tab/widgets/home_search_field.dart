import 'package:Artisan/src/routing/router.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeSearchField extends StatefulWidget {
  const HomeSearchField({super.key});

  @override
  State<HomeSearchField> createState() => _HomeSearchFieldState();
}

class _HomeSearchFieldState extends State<HomeSearchField> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushRoute(const SearchRoute());
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: const DecorationImage(
            fit: BoxFit.fitWidth,
            image: AssetImage(
              "assets/images/ic_search_bg.png",
            ),
          ),
        ),
        child: TextField(
          enabled: false,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 0,
              vertical: 10,
            ),
            prefixIcon: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/ic_search.png',
                  height: 24,
                  width: 24,
                ),
              ],
            ),
            enabledBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            hintText: "Search for paintings,artists",
            hintStyle: GoogleFonts.nunitoSans(
              fontSize: 16,
              fontStyle: FontStyle.italic,
              color: const Color(0xff89909A),
              fontWeight: FontWeight.w400,
            ),
          ),
          style: GoogleFonts.nunitoSans(
            fontSize: 16,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w400,
            color: const Color(0xff89909A),
          ),
        ),
      ),
    );
  }
}
