import 'package:Artisan/src/ui/search/search_page_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:google_fonts/google_fonts.dart';

class SearchTextField extends ConsumerStatefulWidget {
  const SearchTextField({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SearchTextFieldState();
}

class _SearchTextFieldState extends ConsumerState<SearchTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: TextField(
        onChanged: (value) {
          ref.read(searchPageModelProvider.notifier).setText(value);
        },
        controller: TextEditingController(
            text: ref.read(
                searchPageModelProvider.select((value) => value.searchText))),
        // enabled: false,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(top: 15),
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
            color: Color(0xff89909A),
            fontWeight: FontWeight.w700,
          ),
        ),
        style: GoogleFonts.nunitoSans(
          fontSize: 16,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.w700,
          color: Color(0xff89909A),
        ),
      ),
    );
  }
}
