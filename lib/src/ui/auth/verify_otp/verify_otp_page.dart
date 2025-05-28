// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:Artisan/src/routing/router.dart';
import 'package:Artisan/src/ui/auth/verify_otp/widgets/otp_text_field.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../logic/repositories/auth_repository.dart';
import '../../../utils/toast_utils.dart';

import '../widgets/back_btn.dart';
import '../widgets/custom_auth_btn.dart';
import 'verify_otp_model.dart';

@RoutePage()
class VerifyEmailOtpPage extends ConsumerStatefulWidget {
  // final String email;
  const VerifyEmailOtpPage({
    super.key,
    // required this.email,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _VerifyEmailOtpPageState();
}

class _VerifyEmailOtpPageState extends ConsumerState<VerifyEmailOtpPage> {
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
    Future.delayed(Duration.zero, () async {
      ref.read(verifyOtpPageModelProvider.notifier).setEmail(ref
          .read(authRepositoryProvider.select((value) => value.email ?? "")));
      final res =
          await ref.read(verifyOtpPageModelProvider.notifier).sendEmailOtp();
      if (res != '') {
        showErrorMessage(res);
      } else {
        showSuccessMessage('Otp Sent!');
      }
    });
    _initializeOtpTimer();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(verifyOtpPageModelProvider, (previous, next) {});
    ref.listen(authRepositoryProvider, (prev, next) {
      if (prev?.status != next.status) {
        if (next.status == AuthStatus.authenticated) {
          showSuccessMessage('Logged In Successfully!');
          context.replaceRoute(const MainRoute());
        } else if (next.status == AuthStatus.authenticatedNotVerified) {
          context.replaceRoute(const VerifyEmailOtpRoute());
        } else if (next.status == AuthStatus.unauthenticated) {}
      }
    });
    return WillPopScope(
      onWillPop: () async {
        ref.read(authRepositoryProvider.notifier).setEmail("");
        ref.read(authRepositoryProvider.notifier).setPass("");
        ref.read(authRepositoryProvider.notifier).updateUser(null);
        ref
            .read(authRepositoryProvider.notifier)
            .changeState(AuthStatus.unauthenticated);
        context.replaceRoute(const SignInRoute());
        return false;
      },
      child: SafeArea(
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
                              ref
                                  .read(authRepositoryProvider.notifier)
                                  .setEmail("");
                              ref
                                  .read(authRepositoryProvider.notifier)
                                  .setPass("");
                              ref
                                  .read(authRepositoryProvider.notifier)
                                  .updateUser(null);
                              ref
                                  .read(authRepositoryProvider.notifier)
                                  .changeState(AuthStatus.unauthenticated);
                              context.replaceRoute(const SignInRoute());
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
                          // textAlign: TextAlign.center,

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
                      const OtpTextField(),
                      const SizedBox(
                        height: 30,
                      ),
                      Center(
                        child: GestureDetector(
                          onTap: () async {
                            if (!isResending) {
                              if (timeLeft == 0) {
                                final res = await ref
                                    .read(verifyOtpPageModelProvider.notifier)
                                    .sendEmailOtp();
                                if (res != '') {
                                  showErrorMessage(res);
                                } else {
                                  showSuccessMessage('Otp Sent!');
                                }
                                _initializeOtpTimer();
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
                                .read(verifyOtpPageModelProvider.notifier)
                                .updateEmailOtp();
                            if (res != '') {
                              showErrorMessage(res);
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
      ),
    );
  }
}
