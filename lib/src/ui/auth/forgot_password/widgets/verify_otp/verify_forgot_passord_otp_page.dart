// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:Artisan/src/routing/router.dart';
import 'package:Artisan/src/ui/auth/forgot_password/forgot_password_model.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../utils/toast_utils.dart';
import '../../../widgets/back_btn.dart';
import '../../../widgets/custom_auth_btn.dart';
import '../forgot_otp_text_field.dart';

@RoutePage()
class VerifyForgotPasswordOtpPage extends ConsumerStatefulWidget {
  const VerifyForgotPasswordOtpPage({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _VerifyForgotPasswordOtpPageState();
}

class _VerifyForgotPasswordOtpPageState
    extends ConsumerState<VerifyForgotPasswordOtpPage> {
  bool checkBox = false;
  bool isProcessing = false;
  bool isResending = false;
  int timeLeft = 30;
  Timer? _timer;

  _initializeOtpTimer() {
    _timer?.cancel();
    timeLeft = 30;
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (mounted) {
          setState(() {
            --timeLeft;
          });
        }
        if (timeLeft < 1) {
          timer.cancel();
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  void initState() {
    super.initState();
    _initializeOtpTimer();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Image.asset(
              'assets/images/bg_auth.png',
              height: MediaQuery.sizeOf(context).height,
              width: MediaQuery.sizeOf(context).width,
              fit: BoxFit.fill,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(
                      height: 25,
                    ),
                    Row(
                      children: [
                        BackBtn(
                          onTap: () {
                            Navigator.popUntil(
                                context, (route) => route.isFirst);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Text(
                      "Verify Code",
                      style: GoogleFonts.nunitoSans(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 20,
                      child: Text(
                        "Please enter the code we sent to the email",
                        style: GoogleFonts.nunitoSans(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const ForgotOtpTextField(),
                    const SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: GestureDetector(
                        onTap: () async {
                          if (!isResending) {
                            if (timeLeft == 0) {
                              if (mounted) {
                                setState(() {
                                  isResending = true;
                                });
                              }
                              final res = await ref
                                  .read(
                                      forgotPasswordPageModelProvider.notifier)
                                  .sendChangePasswordOtp();
                              if (res.keys.first != true) {
                                showErrorMessage(res.values.first);
                              } else {
                                showSuccessMessage(res.values.first);
                              }
                              _initializeOtpTimer();
                            }
                            if (mounted) {
                              setState(() {
                                isResending = false;
                              });
                            }
                          }
                        },
                        child: isResending
                            ? const SizedBox(
                                height: 15,
                                width: 15,
                                child: CircularProgressIndicator(
                                    strokeWidth: 1.5, color: Colors.white),
                              )
                            : Text(
                                timeLeft == 0
                                    ? "Resend Code"
                                    : "Resend code in 00:${timeLeft < 10 ? "0" : ""}$timeLeft",
                                style: GoogleFonts.nunitoSans(
                                  color: Colors.white,
                                  fontSize: 14,
                                  letterSpacing: -0.011,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    CustomAuthBtn(
                      height: 50,
                      borderColor: Colors.white.withOpacity(.6),
                      isProcessing: isProcessing,
                      onTap: () async {
                        if (!isProcessing) {
                          if (mounted) {
                            setState(() {
                              isProcessing = true;
                            });
                          }
                          final res = await ref
                              .read(forgotPasswordPageModelProvider.notifier)
                              .verifyOtp();
                          if (res != "") {
                            showErrorMessage(res);
                          } else {
                            showSuccessMessage("Otp Verified!");
                            context.replaceRoute(const ChangePasswordRoute());
                          }
                          if (mounted) {
                            setState(() {
                              isProcessing = false;
                            });
                          }
                        }
                      },
                      text: 'Continue',
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
