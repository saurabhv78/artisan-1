import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:google_fonts/google_fonts.dart';

class CustomAuthBtn extends ConsumerStatefulWidget {
  final String text;
  final VoidCallback onTap;
  final bool isProcessing;
  final Color? borderColor;
  final double height;
  final double? width;
  const CustomAuthBtn({
    super.key,
    required this.height,
    required this.isProcessing,
    required this.onTap,
    required this.text,
    this.borderColor,
    this.width,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CustomAuthBtnState();
}

class _CustomAuthBtnState extends ConsumerState<CustomAuthBtn> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          border: Border.all(
              color: widget.borderColor ?? const Color(0xffA39B9B), width: 1),
          borderRadius: BorderRadius.circular(50),
        ),
        height: widget.height,
        width: widget.width,
        child: Center(
          child: widget.isProcessing
              ? const Center(
                  child: SizedBox(
                    height: 25,
                    width: 25,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: FittedBox(
                    child: Text(
                      widget.text,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunitoSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
