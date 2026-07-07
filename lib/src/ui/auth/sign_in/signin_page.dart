// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:Artisan/src/constants/colors.dart';

import 'package:Artisan/src/routing/router.dart';

import 'package:Artisan/src/ui/auth/widgets/back_btn.dart';
import 'package:Artisan/src/ui/auth/widgets/custom_auth_btn.dart';
import 'package:Artisan/src/ui/auth/widgets/custom_auth_text_field.dart';
import 'package:Artisan/src/utils/toast_utils.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../logic/repositories/auth_repository.dart';
import '../tnc/privacy_policy_page.dart';
import '../tnc/tnc_page.dart';
import 'signin_model.dart';

@RoutePage()
class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();

    final remember = prefs.getBool('remember_me') ?? false;
    final savedEmail = prefs.getString('saved_email') ?? '';
    final savedPassword = prefs.getString('saved_password') ?? '';

    if (remember) {
      setState(() {
        checkBox = true;
      });
      ref.read(signInPageModelProvider.notifier).setEmail(savedEmail);
      ref.read(signInPageModelProvider.notifier).setPassword(savedPassword);
    }
  }

  bool checkBox = false;
  bool isProcessing = false;
  bool isFbProcessing = false;
  bool isNotVisible = true;
  // bool isFirstTimeTap = true;
  @override
  Widget build(BuildContext context) {
    ref.listen(signInPageModelProvider, (prev, next) {});
    ref.listen(authRepositoryProvider, (prev, next) {
      if (prev?.status != next.status) {
        if (next.status == AuthStatus.authenticated) {
          if (!next.isGuest) showSuccessMessage('Logged In Successfully!');
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
              /// BACKGROUND IMAGE - Always full screen
              Positioned.fill(
                child: Image.asset(
                  'assets/images/bg_auth.png',
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 50, // iPhone + iPad perfect safe-area
                left: 20,
                child: BackBtn(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    context.replaceRoute(const WelcomeRoute());
                  },
                ),
              ),

              /// MAIN CONTENT
              LayoutBuilder(
                builder: (context, constraints) {
                  bool isTablet = constraints.maxWidth > 600;

                  return Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: isTablet ? 480 : constraints.maxWidth,
                      ),
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(
                          horizontal: isTablet ? 32 : 22,
                          vertical: 20,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 25),

                            const SizedBox(height: 25),

                            Text(
                              "Sign in",
                              style: GoogleFonts.nunitoSans(
                                color: Colors.white,
                                fontSize: isTablet ? 40 : 32,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 10),

                            Text(
                              "Enter the email you would like to use PEA with",
                              style: GoogleFonts.nunitoSans(
                                color: Colors.white,
                                fontSize: isTablet ? 18 : 16,
                              ),
                            ),
                            const SizedBox(height: 40),

                            /// Email
                            CustomAuthTextField(
                              hintText: "Email",
                              isEnabled: !isProcessing,
                              initialText: ref.read(signInPageModelProvider
                                  .select((value) => value.email)),
                              backgroundColor: Colors.black.withOpacity(0.3),
                              onChanged: ref
                                  .read(signInPageModelProvider.notifier)
                                  .setEmail,
                            ),
                            const SizedBox(height: 15),

                            /// Password
                            CustomAuthTextField(
                              hintText: "Password",
                              hideText: isNotVisible,
                              isEnabled: !isProcessing,
                              initialText: ref.read(signInPageModelProvider
                                  .select((value) => value.password)),
                              backgroundColor: Colors.black.withOpacity(0.3),
                              suffix: GestureDetector(
                                onTap: () => setState(() {
                                  isNotVisible = !isNotVisible;
                                }),
                                child: Icon(
                                  isNotVisible
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.white,
                                ),
                              ),
                              onChanged: ref
                                  .read(signInPageModelProvider.notifier)
                                  .setPassword,
                            ),

                            const SizedBox(height: 10),

                            Row(
                              children: [
                                const Spacer(),
                                GestureDetector(
                                  onTap: () => context.navigateTo(
                                    const ForgotPasswordRoute(),
                                  ),
                                  child: Text(
                                    "Forgot Password?",
                                    style: GoogleFonts.nunitoSans(
                                      color: primaryColor,
                                      fontSize: isTablet ? 17 : 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),

                            CustomAuthBtn(
                              text: "Continue",
                              isProcessing: isProcessing,
                              height: 50,
                              backgroundcolor: primaryColor,
                              borderColor: primaryColor,
                              onTap: () async {
                                if (isProcessing) return;

                                setState(() => isProcessing = true);

                                final res = await ref
                                    .read(signInPageModelProvider.notifier)
                                    .loginUser(checkBox: true);

                                if (res.isNotEmpty) showErrorMessage(res);

                                if (mounted) {
                                  setState(() => isProcessing = false);
                                }
                              },
                            ),

                            const SizedBox(height: 15),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Don’t have an account?",
                                    style:
                                        GoogleFonts.nunitoSans(fontSize: 16)),
                                GestureDetector(
                                  onTap: () =>
                                      context.replaceRoute(const SignUpRoute()),
                                  child: Text(
                                    " Sign up",
                                    style: GoogleFonts.nunitoSans(
                                      color: primaryColor,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 50),

                            Row(
                              children: [
                                const Expanded(
                                    child: Divider(color: Colors.black)),
                                Text(" Or Continue with ",
                                    style:
                                        GoogleFonts.nunitoSans(fontSize: 14)),
                                const Expanded(
                                    child: Divider(color: Colors.black)),
                              ],
                            ),

                            const SizedBox(height: 20),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (Platform.isIOS)
                                  GestureDetector(
                                    onTap: () async {
                                      final res = await ref
                                          .read(
                                              signInPageModelProvider.notifier)
                                          .signInWithApple(ref);
                                      // if (res.isNotEmpty) showErrorMessage(res);
                                      if (res.isNotEmpty) {
                                        showAlertBox(context, res);
                                      }
                                    },
                                    child: Image.asset(
                                      'assets/images/ic_apple.png',
                                      width: 45.5,
                                      height: 45.5,
                                    ),
                                  ),
                                if (Platform.isIOS) const SizedBox(width: 20),
                                GestureDetector(
                                  onTap: () async {
                                    if (isFbProcessing) return;
                                    setState(() => isFbProcessing = true);

                                    final res = await ref
                                        .read(signInPageModelProvider.notifier)
                                        .signInWithFacebook(ref);

                                    if (res.isNotEmpty) showErrorMessage(res);

                                    if (mounted) {
                                      setState(() => isFbProcessing = false);
                                    }
                                  },
                                  child: Image.asset(
                                    'assets/images/ic_facebook.png',
                                    width: 45,
                                    height: 45,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                GestureDetector(
                                  onTap: () async {
                                    final res = await ref
                                        .read(signInPageModelProvider.notifier)
                                        .signinWithGoogle();

                                    if (res.isNotEmpty) showErrorMessage(res);
                                  },
                                  child: Image.asset(
                                    'assets/images/ic_google.png',
                                    width: 45,
                                    height: 45,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 30),

                            RichText(
                              text: TextSpan(
                                style: GoogleFonts.nunitoSans(
                                    fontSize: 14, height: 1.6),
                                children: [
                                  TextSpan(
                                    text: "By logging in you agree to our ",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  TextSpan(
                                    text: "Terms & Condition",
                                    style: TextStyle(color: primaryColor),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => showAdaptiveDialog(
                                            context: context,
                                            builder: (_) => const TnCPage(),
                                          ),
                                  ),
                                  TextSpan(
                                    text: " and ",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  TextSpan(
                                    text: "Privacy Policy",
                                    style: TextStyle(color: primaryColor),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => showAdaptiveDialog(
                                            context: context,
                                            builder: (_) =>
                                                const PrivacyPolicyPage(),
                                          ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 40),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    if (!isProcessing) {
                                      if (mounted) {
                                        setState(() {
                                          isProcessing = true;
                                        });
                                      }
                                      final res = await ref
                                          .read(authRepositoryProvider.notifier)
                                          .loginAsGuest();
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
                                  child: Text(
                                    "Continue as Guest",
                                    style: GoogleFonts.nunitoSans(
                                      color: primaryColor,
                                      fontSize: isTablet ? 18 : 16,
                                      letterSpacing: -0.011,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
