// import 'package:Artisan/src/constants/colors.dart';
// import 'package:Artisan/src/routing/router.dart';
// import 'package:Artisan/src/ui/auth/forgot_password/forgot_password_model.dart';
// import 'package:flutter/material.dart';

// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'package:Artisan/src/ui/auth/widgets/back_btn.dart';
// import 'package:Artisan/src/ui/auth/widgets/custom_auth_text_field.dart';
// import 'package:auto_route/auto_route.dart';
// import 'package:google_fonts/google_fonts.dart';

// import '../../../utils/toast_utils.dart';
// import '../widgets/custom_auth_btn.dart';

// @RoutePage()
// class ForgotPasswordPage extends ConsumerStatefulWidget {
//   const ForgotPasswordPage({super.key});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() =>
//       _ForgotPasswordPageState();
// }

// class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
//   bool isProcessing = false;
//   @override
//   Widget build(BuildContext context) {
//     ref.listen(forgotPasswordPageModelProvider, (prev, next) {});
//     return SafeArea(
//       child: Scaffold(
//         body: Stack(
//           children: [
//             Image.asset(
//               'assets/images/bg_auth.png',
//               height: MediaQuery.sizeOf(context).height,
//               width: MediaQuery.sizeOf(context).width,
//               fit: BoxFit.fill,
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 22),
//               child: SingleChildScrollView(
//                 physics: const AlwaysScrollableScrollPhysics(),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     const SizedBox(
//                       height: 25,
//                     ),
//                     Row(
//                       children: [
//                         BackBtn(
//                           onTap: () {
//                             context.maybePop();
//                           },
//                         ),
//                       ],
//                     ),
//                     const SizedBox(
//                       height: 25,
//                     ),
//                     Text(
//                       "Forgot Password?",
//                       style: GoogleFonts.nunitoSans(
//                         color: Colors.white,
//                         fontSize: 31,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 10,
//                     ),
//                     FittedBox(
//                       child: Text(
//                         "Enter the email you want to change the password",
//                         style: GoogleFonts.nunitoSans(
//                           color: Colors.white,
//                           fontSize: 16,
//                           fontWeight: FontWeight.w400,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 15,
//                     ),
//                     CustomAuthTextField(
//                       backgroundColor: Colors.black.withOpacity(0.3),
//                       hintText: 'Email',
//                       isEnabled: !isProcessing,
//                       initialText: ref.read(forgotPasswordPageModelProvider
//                           .select((value) => value.email)),
//                       maxLength: null,
//                       // backgroundColor: Colors.white.withOpacity(0.15),
//                       onChanged: ref
//                           .read(forgotPasswordPageModelProvider.notifier)
//                           .setEmail,
//                     ),
//                     const SizedBox(
//                       height: 30,
//                     ),
//                     CustomAuthBtn(
//                       backgroundcolor: primaryColor,
//                       height: 50,
//                       borderColor: primaryColor,
//                       isProcessing: isProcessing,
//                       onTap: () async {
//                         if (!isProcessing) {
//                           if (mounted) {
//                             setState(() {
//                               isProcessing = true;
//                             });
//                           }
//                           final res = await ref
//                               .read(forgotPasswordPageModelProvider.notifier)
//                               .sendChangePasswordOtp();
//                           if (res.keys.first != true) {
//                             showErrorMessage(res.values.first);
//                           } else {
//                             showSuccessMessage(res.values.first);
//                             context.navigateTo(
//                                 const VerifyForgotPasswordOtpRoute());
//                           }
//                           if (mounted) {
//                             setState(() {
//                               isProcessing = false;
//                             });
//                           }
//                         }
//                       },
//                       text: 'Continue',
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:Artisan/src/constants/colors.dart';
import 'package:Artisan/src/routing/router.dart';
import 'package:Artisan/src/ui/auth/forgot_password/forgot_password_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artisan/src/ui/auth/widgets/back_btn.dart';
import 'package:Artisan/src/ui/auth/widgets/custom_auth_text_field.dart';
import 'package:auto_route/auto_route.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../utils/toast_utils.dart';
import '../widgets/custom_auth_btn.dart';

@RoutePage()
class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  bool isProcessing = false;

  @override
  Widget build(BuildContext context) {
    ref.listen(forgotPasswordPageModelProvider, (prev, next) {});

    return Scaffold(
      body: Stack(
        children: [
          /// BACKGROUND
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg_auth.png',
              fit: BoxFit.cover,
            ),
          ),

          /// 🔵 FIXED BACK BUTTON — ALWAYS ON TOP
          Positioned(
            top: 50,
            left: 20,
            child: BackBtn(
              onTap: () {
                FocusScope.of(context).unfocus();
                context.maybePop();
              },
            ),
          ),

          /// MAIN CONTENT
          Positioned.fill(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final bool isTablet = constraints.maxWidth > 600;

                return Center(
                  child: Container(
                    width: isTablet ? 450 : double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 140),

                          Text(
                            "Forgot Password?",
                            style: GoogleFonts.nunitoSans(
                              color: Colors.white,
                              fontSize: isTablet ? 38 : 31,
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          const SizedBox(height: 10),

                          FittedBox(
                            child: Text(
                              "Enter the email you want to change the password",
                              style: GoogleFonts.nunitoSans(
                                color: Colors.white,
                                fontSize: isTablet ? 18 : 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),

                          const SizedBox(height: 25),

                          /// EMAIL INPUT
                          CustomAuthTextField(
                            backgroundColor: Colors.black.withOpacity(0.3),
                            hintText: 'Email',
                            isEnabled: !isProcessing,
                            initialText: ref.read(
                                forgotPasswordPageModelProvider
                                    .select((value) => value.email)),
                            maxLength: null,
                            onChanged: ref
                                .read(forgotPasswordPageModelProvider.notifier)
                                .setEmail,
                          ),

                          const SizedBox(height: 35),

                          /// CONTINUE BUTTON
                          CustomAuthBtn(
                            backgroundcolor: primaryColor,
                            height: 50,
                            borderColor: primaryColor,
                            isProcessing: isProcessing,
                            onTap: () async {
                              if (!isProcessing) {
                                setState(() => isProcessing = true);

                                final res = await ref
                                    .read(forgotPasswordPageModelProvider
                                        .notifier)
                                    .sendChangePasswordOtp();

                                if (res.keys.first != true) {
                                  showErrorMessage(res.values.first);
                                } else {
                                  showSuccessMessage(res.values.first);
                                  context.navigateTo(
                                      const VerifyForgotPasswordOtpRoute());
                                }

                                if (mounted) {
                                  setState(() => isProcessing = false);
                                }
                              }
                            },
                            text: 'Continue',
                          ),

                          const SizedBox(height: 50),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
