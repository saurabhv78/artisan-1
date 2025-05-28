import 'package:Artisan/src/ui/auth/forgot_password/forgot_password_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';

class ForgotOtpTextField extends ConsumerStatefulWidget {
  const ForgotOtpTextField({
    super.key,
  });

  @override
  ConsumerState createState() => _ForgotOtpTextFieldState();
}

class _ForgotOtpTextFieldState extends ConsumerState<ForgotOtpTextField> {
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
        ref.read(forgotPasswordPageModelProvider.notifier).setOtp(value);
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
      onChanged: ref.read(forgotPasswordPageModelProvider.notifier).setOtp,
      contentPadding: const EdgeInsets.only(
        top: 15,
        left: 2,
      ),
    );
  }
}
