// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../logic/repositories/auth_repository.dart';
import '../../routing/router.dart';
import '../../widgets/custom_scaffold.dart';

@RoutePage()
class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  bool isCentered = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() {
          isCentered = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    ref.listen(authRepositoryProvider, (previous, next) async {
      await Future.delayed(const Duration(milliseconds: 2000));
      if (next.status == AuthStatus.authenticated) {
        context.replaceRoute(const MainRoute());
      } else if (next.status == AuthStatus.authenticatedNotVerified) {
        context.replaceRoute(const VerifyEmailOtpRoute());
      } else if (next.status == AuthStatus.unauthenticated) {
        context.replaceRoute(const WelcomeRoute());
      }
    });
    return CustomScaffold(
      bgColor: Colors.white,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            alignment: Alignment.topLeft,
            children: [
              // SizedBox(
              //   height: MediaQuery.sizeOf(context).height,
              //   width: MediaQuery.sizeOf(context).width,
              //   child: Image.asset(
              //     'assets/images/img_splash.png',
              //     height: MediaQuery.sizeOf(context).height,
              //     width: MediaQuery.sizeOf(context).width,
              //     fit: BoxFit.cover,
              //   ),
              // ),
              AnimatedPositioned(
                curve: Curves.easeOut,
                top: isCentered ? size.height / 2 - 95 : -140,
                left: isCentered ? size.width / 2 - 85 : -80,
                duration: const Duration(
                  milliseconds: 800,
                ),
                child: AnimatedScale(
                  curve: Curves.easeOut,
                  scale: isCentered ? 1 : 0,
                  duration: const Duration(
                    milliseconds: 1000,
                  ),
                  child: SvgPicture.asset(
                    'assets/images/A.svg',
                    color: Colors.red,
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
