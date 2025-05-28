// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:google_fonts/google_fonts.dart';

import '../constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomButton extends ConsumerStatefulWidget {
  final String text;
  final VoidCallback onTap;
  final double width;
  final double height;
  final bool secondUI;
  final bool isProcessing;
  const CustomButton({
    super.key,
    required this.text,
    required this.onTap,
    this.width = 250,
    this.height = 50,
    this.secondUI = false,
    required this.isProcessing,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CustomButtonState();
}

class _CustomButtonState extends ConsumerState<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          gradient: widget.secondUI ? null : btnGradient,
          color: widget.secondUI ? Colors.white : null,
          border: widget.secondUI
              ? Border.all(color: primaryColor, width: 1)
              : null,
          borderRadius: BorderRadius.circular(50),
        ),
        height: widget.height,
        width: widget.width,
        child: Center(
          child: widget.isProcessing
              ? Center(
                  child: SizedBox(
                    height: 25,
                    width: 25,
                    child: CircularProgressIndicator(
                      color: widget.secondUI ? primaryColor : Colors.white,
                      strokeWidth: 2,
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: FittedBox(
                    child: Text(
                      widget.text,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunitoSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: widget.secondUI ? primaryColor : Colors.white,
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
