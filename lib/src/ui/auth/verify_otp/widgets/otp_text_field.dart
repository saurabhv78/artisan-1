import 'package:Artisan/src/ui/auth/verify_otp/verify_otp_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';

class OtpTextField extends ConsumerStatefulWidget {
  const OtpTextField({
    super.key,
  });

  @override
  ConsumerState createState() => _OtpTextFieldState();
}

class _OtpTextFieldState extends ConsumerState<OtpTextField> {
  late final OtpFieldController _controller;
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = OtpFieldController();
  }

  @override
  Widget build(BuildContext context) {
    const otpLength = 4;

    return OTPTextField(
      onCompleted: (value) {
        ref.read(verifyOtpPageModelProvider.notifier).setOtp(value);
      },
      length: otpLength,
      width: 250,
      spaceBetween: 10,
      fieldWidth: 50,
      outlineBorderRadius: 8,
      style: GoogleFonts.nunito(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      textFieldAlignment: MainAxisAlignment.spaceBetween,
      controller: _controller,
      fieldStyle: FieldStyle.box,
      otpFieldStyle: OtpFieldStyle(
        backgroundColor: Colors.white.withOpacity(0.2),
        borderColor: Colors.white.withOpacity(.6),
        focusBorderColor: Colors.white.withOpacity(.6),
        disabledBorderColor: Colors.white.withOpacity(.6),
        enabledBorderColor: Colors.white.withOpacity(.6),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 15),
      onChanged: ref.read(verifyOtpPageModelProvider.notifier).setOtp,
      contentPadding: const EdgeInsets.only(
        top: 15,
        left: 2,
      ),
    );
  }
}
