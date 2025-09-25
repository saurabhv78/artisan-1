// ignore_for_file: deprecated_member_use

import 'package:Artisan/src/constants/colors.dart';
import 'package:Artisan/src/routing/router.dart';
import 'package:Artisan/src/ui/auth/sign_up/sign_up_model.dart';
import 'package:Artisan/src/ui/auth/tnc/privacy_policy_page.dart';
import 'package:Artisan/src/ui/auth/tnc/tnc_page.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:google_fonts/google_fonts.dart';

import '../../../logic/repositories/auth_repository.dart';
import '../../../utils/toast_utils.dart';
import '../widgets/back_btn.dart';
import '../widgets/custom_auth_btn.dart';
import '../widgets/custom_auth_text_field.dart';

@RoutePage()
class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  bool isProcessing = false;
  bool isNotVisible = true;
  bool isNotVisible2 = true;
  @override
  Widget build(BuildContext context) {
    ref.listen(signUpPageModelProvider, (prev, next) {});
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
        context.replaceRoute(const WelcomeRoute());
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
                              context.replaceRoute(const WelcomeRoute());
                            },
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      FittedBox(
                        child: Text(
                          "Welcome to ARTISANS",
                          style: GoogleFonts.nunitoSans(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      CustomAuthTextField(
                        hintText: 'Full Name',
                        initialText: ref.read(signUpPageModelProvider
                            .select((value) => value.name)),
                        isEnabled: !isProcessing,
                        maxLength: null,
                        backgroundColor: Colors.white.withOpacity(0.15),
                        onChanged:
                            ref.read(signUpPageModelProvider.notifier).setName,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      CustomAuthTextField(
                        hintText: 'Email',
                        isEnabled: !isProcessing,
                        initialText: ref.read(signUpPageModelProvider
                            .select((value) => value.email)),
                        maxLength: null,
                        backgroundColor: Colors.white.withOpacity(0.15),
                        onChanged:
                            ref.read(signUpPageModelProvider.notifier).setEmail,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      CustomAuthTextField(
                        hintText: 'Mobile Number',
                        isEnabled: !isProcessing,
                        isDigitOnly: true,
                        initialText: ref.read(signUpPageModelProvider
                            .select((value) => value.mobile)),
                        maxLength: 10,
                        backgroundColor: Colors.white.withOpacity(0.15),
                        onChanged: ref
                            .read(signUpPageModelProvider.notifier)
                            .setMobile,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      CustomAuthTextField(
                        hideText: isNotVisible,
                        suffix: GestureDetector(
                          onTap: () {
                            if (mounted) {
                              setState(() {
                                isNotVisible = !isNotVisible;
                              });
                            }
                          },
                          child: Icon(
                            isNotVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.white,
                          ),
                        ),
                        hintText: 'Password',
                        isEnabled: !isProcessing,
                        initialText: ref.read(signUpPageModelProvider
                            .select((value) => value.password)),
                        maxLength: null,
                        backgroundColor: Colors.white.withOpacity(0.15),
                        onChanged: ref
                            .read(signUpPageModelProvider.notifier)
                            .setPassword,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      CustomAuthTextField(
                        hideText: isNotVisible2,
                        suffix: GestureDetector(
                          onTap: () {
                            if (mounted) {
                              setState(() {
                                isNotVisible2 = !isNotVisible2;
                              });
                            }
                          },
                          child: Icon(
                            isNotVisible2
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.white,
                          ),
                        ),
                        hintText: 'Confirm Password',
                        isEnabled: !isProcessing,
                        initialText: ref.read(signUpPageModelProvider
                            .select((value) => value.confirmPassword)),
                        maxLength: null,
                        backgroundColor: Colors.white.withOpacity(0.15),
                        onChanged: ref
                            .read(signUpPageModelProvider.notifier)
                            .setConfPass,
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
                                .read(signUpPageModelProvider.notifier)
                                .registerUser();
                            if (res != '') {
                              showErrorMessage(res);
                            } else {
                              showSuccessMessage("User registered");
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
                        height: 15,
                      ),
                      RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(
                          style: GoogleFonts.nunitoSans(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              height: 1.7),
                          children: [
                            TextSpan(
                              text: 'By Signing up you agree to our ',
                              style: GoogleFonts.nunitoSans(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            TextSpan(
                              text: 'Terms & Condition',
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  showAdaptiveDialog(
                                    context: context,
                                    builder: (context) => Padding(
                                      padding: const EdgeInsets.all(30.0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: const TnCPage(),
                                      ),
                                    ),
                                  );
                                },
                              style: GoogleFonts.nunitoSans(
                                color: primaryColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            TextSpan(
                              text: ' and ',
                              style: GoogleFonts.nunitoSans(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            TextSpan(
                              text: 'Privacy Policy',
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  showAdaptiveDialog(
                                    context: context,
                                    builder: (context) => Padding(
                                      padding: const EdgeInsets.all(30.0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: const PrivacyPolicyPage(),
                                      ),
                                    ),
                                  );
                                },
                              style: GoogleFonts.nunitoSans(
                                color: primaryColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 80,
                      ),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: GoogleFonts.nunitoSans(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          children: [
                            TextSpan(
                              text: 'Already have an account? ',
                              style: GoogleFonts.nunitoSans(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            TextSpan(
                              text: 'Login',
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  context.replaceRoute(const SignInRoute());
                                },
                              style: GoogleFonts.nunitoSans(
                                color: primaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
