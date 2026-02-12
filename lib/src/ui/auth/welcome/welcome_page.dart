// import 'package:Artisan/src/routing/router.dart';
// import 'package:Artisan/src/ui/auth/widgets/custom_auth_btn.dart';
// import 'package:auto_route/auto_route.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'package:google_fonts/google_fonts.dart';

// @RoutePage()
// class WelcomePage extends ConsumerStatefulWidget {
//   const WelcomePage({super.key});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _WelcomePageState();
// }

// class _WelcomePageState extends ConsumerState<WelcomePage> {
//   @override
//   Widget build(BuildContext context) {
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
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   // mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const SizedBox(
//                       height: 200,
//                     ),
//                     FittedBox(
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             "Welcome to",
//                             style: GoogleFonts.nunitoSans(
//                               color: Colors.white,
//                               fontSize: 32,
//                               fontWeight: FontWeight.w400,
//                             ),
//                           ),
//                           Text(
//                             " ARTISANS",
//                             style: GoogleFonts.nunitoSans(
//                               color: Colors.white,
//                               fontSize: 32,
//                               fontWeight: FontWeight.w700,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 40,
//                     ),
//                     Text(
//                       "A community marketplace for buying and selling of paintings and art exhibits",
//                       // textAlign: TextAlign.center,
//                       style: GoogleFonts.nunitoSans(
//                         color: Colors.white,
//                         fontSize: 19,
//                         fontWeight: FontWeight.w400,
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 100,
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         CustomAuthBtn(
//                           height: 50,
//                           isProcessing: false,
//                           onTap: () {
//                             context.replaceRoute(const SignInRoute());
//                           },
//                           text: 'Let\'s Get Started',
//                           width: 188,
//                         )
//                       ],
//                     ),
//                     const SizedBox(
//                       height: 200,
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
/////////// undo
// import 'package:Artisan/src/routing/router.dart';
// import 'package:Artisan/src/ui/auth/widgets/custom_auth_btn.dart';
// import 'package:auto_route/auto_route.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_fonts/google_fonts.dart';

// @RoutePage()
// class WelcomePage extends ConsumerStatefulWidget {
//   const WelcomePage({super.key});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _WelcomePageState();
// }

// class _WelcomePageState extends ConsumerState<WelcomePage> {
//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;

//     final bool isTablet = width > 600;

//     return SafeArea(
//       child: Scaffold(
//         body: Stack(
//           children: [
//             /// Background Image Responsive
//             Image.asset(
//               'assets/images/bg_auth.png',
//               height: height,
//               width: width,
//               fit: BoxFit.cover,
//             ),

//             LayoutBuilder(
//               builder: (context, constraints) {
//                 return Padding(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: isTablet ? width * 0.15 : 22,
//                   ),
//                   child: SingleChildScrollView(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: [
//                         SizedBox(height: height * 0.20),

//                         /// Title Section
//                         FittedBox(
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                 "Welcome to",
//                                 style: GoogleFonts.nunitoSans(
//                                   color: Colors.white,
//                                   fontSize: isTablet ? 48 : 32,
//                                   fontWeight: FontWeight.w400,
//                                 ),
//                               ),
//                               Text(
//                                 " ARTISANS",
//                                 style: GoogleFonts.nunitoSans(
//                                   color: Colors.white,
//                                   fontSize: isTablet ? 48 : 32,
//                                   fontWeight: FontWeight.w700,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),

//                         SizedBox(height: height * 0.04),

//                         /// Description
//                         Text(
//                           "A community marketplace for buying and selling of paintings and art exhibits",
//                           style: GoogleFonts.nunitoSans(
//                             color: Colors.white,
//                             fontSize: isTablet ? 26 : 19,
//                             fontWeight: FontWeight.w400,
//                           ),
//                         ),

//                         SizedBox(height: height * 0.12),

//                         /// Button
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             CustomAuthBtn(
//                               height: isTablet ? 65 : 50,
//                               isProcessing: false,
//                               onTap: () {
//                                 context.replaceRoute(const SignInRoute());
//                               },
//                               text: 'Let\'s Get Started',
//                               width: isTablet ? 250 : 188,
//                             )
//                           ],
//                         ),

//                         SizedBox(height: height * 0.20),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:developer';
import 'package:Artisan/src/routing/router.dart';
import 'package:Artisan/src/ui/auth/widgets/custom_auth_btn.dart';
import 'package:Artisan/src/widgets/custom_scaffold.dart';
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
  final PageController _pageController = PageController();
  int currentIndex = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "image": "assets/images/Landing-portrait 1.png",
      "title": "Discover Masterpieces",
      "subtitle":
          "Find a curated feed of new paintings, exhibits, and featured artists waiting to be explored every day."
    },
    {
      "image": "assets/images/Product-portrait.png",
      "title": "Deep Dive into Artistry",
      "subtitle":
          "View high-resolution images, read the artist's story, and see detailed provenance before making a secure purchase."
    },
    {
      "image": "assets/images/Landing-portrait 1 (2).png",
      "title": "Find Your Next Exhibit",
      "subtitle":
          "View high-resolution images, read the artist's story, and see detailed provenance before making a secure purchase."
    },
    {
      "image": "assets/images/Checkout-portrait.png",
      "title": "Secure and Simple Checkout",
      "subtitle":
          "Complete your purchase in a few taps. Our secure payment gateway ensures a seamless and protected transaction for every piece of art."
    }
  ];

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final bool isTablet = width > 600;

    return CustomScaffold(
      child: Stack(
        children: [
          /// Background
          // Image.asset(
          //   'assets/images/bg_auth.png',
          //   height: height,
          //   width: width,
          //   fit: BoxFit.cover,
          // ),

          /// Onboarding Slides
          Column(
            children: [
              SizedBox(height: height * 0.05),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: onboardingData.length,
                  onPageChanged: (index) {
                    setState(() => currentIndex = index);
                  },
                  itemBuilder: (context, index) {
                    final data = onboardingData[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: isTablet ? width * 0.13 : 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 50),
                          Text(
                            data["title"]!,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.nunitoSans(
                              color: Colors.black,
                              fontSize: isTablet ? 34 : 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            data["subtitle"]!,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.nunitoSans(
                              color: Colors.black,
                              fontSize: isTablet ? 24 : 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 0),
                            child: SizedBox(
                              height: isTablet ? height * 0.64 : height * 0.60,
                              child: Image.asset(
                                data["image"]!,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              /// Dots Indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  onboardingData.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.all(5),
                    height: 10,
                    width: currentIndex == index ? 28 : 10,
                    decoration: BoxDecoration(
                      color: currentIndex == index
                          ? Colors.grey.shade500
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// Buttons
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? width * 0.15 : 22),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// Previous
                    if (currentIndex > 0)
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: const Text("Previous",
                            style: TextStyle(color: Colors.black)),
                      )
                    else
                      const SizedBox(width: 100),

                    /// Next / Get Started
                    currentIndex == onboardingData.length - 1
                        ? CustomAuthBtn(
                            height: isTablet ? 42 : 40,
                            isProcessing: false,
                            onTap: () {
                              context.replaceRoute(const SignInRoute());
                            },
                            text: "Let’s Get Started",
                            backgroundcolor: Colors.red,
                            width: isTablet ? 180 : 150,
                          )
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            child: const Text("Next",
                                style: TextStyle(color: Colors.black)),
                          ),
                  ],
                ),
              ),

              SizedBox(height: height * 0.04),
            ],
          ),

          /// ⭐ WORKING SKIP BUTTON (TOP OF STACK)
          Positioned(
            right: isTablet ? 40 : 20,
            top: isTablet ? 80 : 40,
            child: InkWell(
              onTap: () {
                log("Skip pressed → SignIn");
                context.replaceRoute(const SignInRoute());
              },
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Text(
                  "Skip",
                  style: GoogleFonts.nunitoSans(
                    color: Colors.black,
                    fontSize: isTablet ? 22 : 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
