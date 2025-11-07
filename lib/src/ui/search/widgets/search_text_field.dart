import 'dart:async';

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
  TextEditingController? _controller;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
        text: ref
            .read(searchPageModelProvider.select((value) => value.searchText)));
  }

  void _onSearchChanged(String value) {
    // Cancel previous timer
    _debounce?.cancel();

    // Set a new debounce timer
    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(searchPageModelProvider.notifier).setText(value);
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: TextField(
        controller: _controller,
        onChanged: _onSearchChanged,
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
          focusedBorder: InputBorder.none,
          hintText: "Search for paintings, artists...",
          hintStyle: GoogleFonts.nunitoSans(
            fontSize: 16,
            fontStyle: FontStyle.italic,
            color: const Color(0xff89909A),
            fontWeight: FontWeight.w700,
          ),
        ),
        style: GoogleFonts.nunitoSans(
          fontSize: 16,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.w700,
          color: const Color(0xff89909A),
        ),
      ),
    );
  }
}
