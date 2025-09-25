// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:google_fonts/google_fonts.dart';

import '../../../constants/colors.dart';

class CustomAuthTextField extends ConsumerStatefulWidget {
  final String hintText;
  final String initialText;
  final VoidCallback? onTap;
  final String hint;
  final bool isShowMaxLength;
  final bool isDigitOnly;
  final bool? isEnabled;
  final Widget? suffix;
  final int? maxlines;

  final Color? backgroundColor;
  final int? maxLength;
  final int? minLines;
  final bool hideText;
  final Function(String value) onChanged;
  const CustomAuthTextField({
    super.key,
    this.onTap,
    required this.hintText,
    required this.initialText,
    this.hint = '',
    this.minLines,
    this.isShowMaxLength = false,
    this.isDigitOnly = false,
    this.isEnabled = true,
    this.maxlines = 1,
    this.backgroundColor = Colors.white,
    required this.maxLength,
    this.hideText = false,
    this.suffix,
    required this.onChanged,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CustomAuthTextFieldState();
}

class _CustomAuthTextFieldState extends ConsumerState<CustomAuthTextField> {
  @override
  void initState() {
    super.initState();
  }

  Widget counter(
    BuildContext context, {
    required int currentLength,
    required int? maxLength,
    required bool isFocused,
  }) {
    return Text(
      '$currentLength/$maxLength',
      semanticsLabel: 'character count',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(4),
          ),
          height: 48,
          child: TextFormField(
            onTap: widget.onTap,
            minLines: widget.minLines,
            maxLines: widget.maxlines,
            enabled: widget.isEnabled,
            buildCounter: counter,
            controller: TextEditingController(text: widget.initialText),
            onChanged: widget.onChanged,
            maxLength: widget.maxLength,
            obscureText: widget.hideText,
            cursorColor: Colors.white,
            scrollPadding: const EdgeInsets.only(bottom: 300),
            keyboardType: widget.isDigitOnly
                ? const TextInputType.numberWithOptions(decimal: false)
                : null,
            decoration: InputDecoration(
              counterText: widget.isShowMaxLength ? null : '',
              counterStyle: GoogleFonts.outfit(
                fontSize: 14,
                color: widget.isEnabled ?? true
                    ? secondaryColor
                    : secondaryColor.withOpacity(0.5),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              enabledBorder:
                  const OutlineInputBorder(borderSide: BorderSide.none),
              disabledBorder:
                  const OutlineInputBorder(borderSide: BorderSide.none),
              suffixIcon: widget.suffix,
              focusedBorder:
                  const OutlineInputBorder(borderSide: BorderSide.none),
              hintText: widget.hintText,
              hintStyle: GoogleFonts.nunitoSans(
                fontSize: 16,
                color: Colors.grey[300],
                fontWeight: FontWeight.w400,
              ),
            ),
            inputFormatters: widget.isDigitOnly
                ? [
                    FilteringTextInputFormatter.digitsOnly,
                  ]
                : null,
            style: GoogleFonts.nunitoSans(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
