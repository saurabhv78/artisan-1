// ignore_for_file: deprecated_member_use

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
import 'package:google_sign_in/google_sign_in.dart';
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
                              Focus.maybeOf(context)?.unfocus();
                              context.replaceRoute(const WelcomeRoute());
                            },
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Text(
                        "Sign in",
                        style: GoogleFonts.nunitoSans(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      FittedBox(
                        child: Text(
                          "Enter the email you would like to use PEA with",
                          // textAlign: TextAlign.center,

                          style: GoogleFonts.nunitoSans(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      CustomAuthTextField(
                        hintText: 'Email/Phone Number',
                        isEnabled: !isProcessing,
                        initialText: ref.read(signInPageModelProvider
                            .select((value) => value.email)),
                        maxLength: null,
                        backgroundColor: Colors.white.withOpacity(0.15),
                        onChanged:
                            ref.read(signInPageModelProvider.notifier).setEmail,
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
                        initialText: ref.read(signInPageModelProvider
                            .select((value) => value.password)),
                        maxLength: null,
                        backgroundColor: Colors.white.withOpacity(0.15),
                        onChanged: ref
                            .read(signInPageModelProvider.notifier)
                            .setPassword,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          // SizedBox(
                          //   width: 18,
                          //   child: ClipRRect(
                          //     borderRadius: BorderRadius.circular(8),
                          //     child: Checkbox(
                          //       value: checkBox,
                          //       splashRadius: 0,
                          //       focusColor: primaryColor,
                          //       checkColor: Colors.white,
                          //       activeColor: primaryColor,
                          //       side: const BorderSide(color: Colors.white),
                          //       shape: RoundedRectangleBorder(
                          //           borderRadius: BorderRadius.circular(10)),
                          //       onChanged: (value) async {
                          //         setState(() => checkBox = value ?? false);

                          //         final prefs =
                          //             await SharedPreferences.getInstance();
                          //         await prefs.setBool('remember_me', checkBox);

                          //         if (!checkBox) {
                          //           // Clear stored credentials if unchecked
                          //           await prefs.remove('saved_email');
                          //           await prefs.remove('saved_password');
                          //         }
                          //       },
                          //     ),
                          //   ),
                          // ),
                          // const SizedBox(
                          //   width: 5,
                          // ),
                          // Text(
                          //   "Remember me",
                          //   style: GoogleFonts.nunitoSans(
                          //     color: Colors.white,
                          //     fontSize: 16,
                          //     fontWeight: FontWeight.w400,
                          //   ),
                          // ),
                          const Expanded(child: SizedBox()),
                          GestureDetector(
                            onTap: () {
                              context.navigateTo(const ForgotPasswordRoute());
                            },
                            child: Text(
                              "Forgot Password?",
                              style: GoogleFonts.nunitoSans(
                                color: primaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 20,
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
                                .read(signInPageModelProvider.notifier)
                                .loginUser(checkBox: true);
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
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don’t have an account?",
                            style: GoogleFonts.nunitoSans(
                              color: Colors.white,
                              fontSize: 16,
                              letterSpacing: -0.011,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              context.replaceRoute(const SignUpRoute());
                            },
                            child: Text(
                              " Sign up",
                              style: GoogleFonts.nunitoSans(
                                color: primaryColor,
                                fontSize: 16,
                                letterSpacing: -0.011,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                      // const SizedBox(
                      //   height: 15,
                      // ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     GestureDetector(
                      //       onTap: () async {
                      //         if (!isProcessing) {
                      //           if (mounted) {
                      //             setState(() {
                      //               isProcessing = true;
                      //             });
                      //           }
                      //           final res = await ref
                      //               .read(authRepositoryProvider.notifier)
                      //               .loginAsGuest();
                      //           if (res != '') {
                      //             showErrorMessage(res);
                      //           }
                      //           if (mounted) {
                      //             setState(() {
                      //               isProcessing = false;
                      //             });
                      //           }
                      //         }
                      //       },
                      //       child: Text(
                      //         "Continue as Guest",
                      //         style: GoogleFonts.nunitoSans(
                      //           color: primaryColor,
                      //           fontSize: 16,
                      //           letterSpacing: -0.011,
                      //           fontWeight: FontWeight.w400,
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),

                      const SizedBox(
                        height: 60,
                      ),
                      Row(
                        children: [
                          const Expanded(
                            child: Divider(
                              color: Colors.white,
                              thickness: 1,
                            ),
                          ),
                          Text(
                            " Or Continue with ",
                            style: GoogleFonts.nunitoSans(
                              color: Colors.white,
                              fontSize: 14,
                              letterSpacing: -0.011,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const Expanded(
                            child: Divider(
                              color: Colors.white,
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              GoogleSignIn.instance.disconnect();
                              showSuccessMessage("Coming Soon!");
                            },
                            child: Image.asset(
                              'assets/images/ic_apple.png',
                              width: 45.5,
                              height: 45.5,
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          GestureDetector(
                            onTap: () async {
                              if (!isFbProcessing) {
                                if (mounted) {
                                  setState(() {
                                    isFbProcessing = true;
                                  });
                                }
                                final res = await ref
                                    .read(signInPageModelProvider.notifier)
                                    .signInWithFacebook();
                                if (res != '') {
                                  showErrorMessage(res);
                                }
                                if (mounted) {
                                  setState(() {
                                    isFbProcessing = false;
                                  });
                                }
                              }
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/ic_facebook.png',
                                  width: 45.5,
                                  height: 45.5,
                                ),
                                if (isFbProcessing)
                                  Center(
                                    child: Container(
                                      height: 27,
                                      width: 27,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.5),
                                      ),
                                      child: const CircularProgressIndicator(
                                        color: Colors.red,
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          GestureDetector(
                            onTap: () async {
                              final res = await ref
                                  .read(signInPageModelProvider.notifier)
                                  .signinWithGoogle();
                              if (res != '') {
                                showErrorMessage(res);
                              }
                            },
                            child: Image.asset(
                              'assets/images/ic_google.png',
                              width: 45.5,
                              height: 45.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 60,
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
                              text: 'By Logging in you agree to our ',
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
                        height: 40,
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
