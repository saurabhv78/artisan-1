import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:google_fonts/google_fonts.dart';

import '../constants/colors.dart';

class TryAgainWidget extends ConsumerStatefulWidget {
  final VoidCallback onTap;
  final bool isProcessing;
  final bool noInternet;
  final String errMessage;
  const TryAgainWidget({
    super.key,
    required this.onTap,
    this.noInternet = false,
    required this.isProcessing,
    this.errMessage = "Something Went Wrong!!!",
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TryAgainWidgetState();
}

class _TryAgainWidgetState extends ConsumerState<TryAgainWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.isProcessing
        ? SizedBox(
            height: MediaQuery.sizeOf(context).height / 1.2,
            child: const Center(
              child: SizedBox(
                height: 30,
                width: 30,
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              ),
            ),
          )
        : SizedBox(
            height: MediaQuery.sizeOf(context).height / 1.3,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.errMessage,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunitoSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                        onPressed: widget.onTap,
                        icon: const Icon(
                          Icons.refresh,
                          color: primaryColor,
                          size: 18,
                        ),
                        label: Text(
                          'Try Again',
                          style: GoogleFonts.nunitoSans(
                            fontSize: 14,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
