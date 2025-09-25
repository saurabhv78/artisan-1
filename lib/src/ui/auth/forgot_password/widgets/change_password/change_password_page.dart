// ignore_for_file: use_build_context_synchronously

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:google_fonts/google_fonts.dart';

import '../../../../../utils/toast_utils.dart';
import '../../../widgets/back_btn.dart';
import '../../../widgets/custom_auth_btn.dart';
import '../../../widgets/custom_auth_text_field.dart';
import '../../forgot_password_model.dart';

@RoutePage()
class ChangePasswordPage extends ConsumerStatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ChangePasswordPageState();
}

class _ChangePasswordPageState extends ConsumerState<ChangePasswordPage> {
  bool isProcessing = false;
  bool isNotVisible = true;
  bool isNotVisible2 = true;
  @override
  Widget build(BuildContext context) {
    ref.listen(forgotPasswordPageModelProvider, (prev, next) {});
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
                            context.maybePop();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Text(
                      "Change Password",
                      style: GoogleFonts.nunitoSans(
                        color: Colors.white,
                        fontSize: 31,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Enter the new password",
                      style: GoogleFonts.nunitoSans(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomAuthTextField(
                      hintText: 'Password',
                      hideText: isNotVisible,
                      isEnabled: !isProcessing,
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
                      initialText: ref.read(forgotPasswordPageModelProvider
                          .select((value) => value.password)),
                      maxLength: null,
                      backgroundColor: Colors.white.withOpacity(0.15),
                      onChanged: ref
                          .read(forgotPasswordPageModelProvider.notifier)
                          .setPassword,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomAuthTextField(
                      hintText: 'Confirm Password',
                      isEnabled: !isProcessing,
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
                      initialText: ref.read(forgotPasswordPageModelProvider
                          .select((value) => value.confPass)),
                      maxLength: null,
                      backgroundColor: Colors.white.withOpacity(0.15),
                      onChanged: ref
                          .read(forgotPasswordPageModelProvider.notifier)
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
                              .read(forgotPasswordPageModelProvider.notifier)
                              .changePassword();
                          if (res.keys.first != true) {
                            showErrorMessage(res.values.first);
                          } else {
                            showSuccessMessage(res.values.first);
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);
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
