import 'package:Artisan/src/routing/router.dart';
import 'package:Artisan/src/ui/auth/widgets/custom_auth_btn.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:google_fonts/google_fonts.dart';

@RoutePage()
class WelcomePage extends ConsumerStatefulWidget {
  const WelcomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WelcomePageState();
}

class _WelcomePageState extends ConsumerState<WelcomePage> {
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 200,
                    ),
                    FittedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Welcome to",
                            style: GoogleFonts.nunitoSans(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            " ARTISANS",
                            style: GoogleFonts.nunitoSans(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Text(
                      "A community marketplace for buying and selling of paintings and art exhibits",
                      // textAlign: TextAlign.center,
                      style: GoogleFonts.nunitoSans(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(
                      height: 100,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CustomAuthBtn(
                          height: 50,
                          isProcessing: false,
                          onTap: () {
                            context.replaceRoute(const SignInRoute());
                          },
                          text: 'Let\'s Get Started',
                          width: 188,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 200,
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
