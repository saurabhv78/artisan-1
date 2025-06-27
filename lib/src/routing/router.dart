import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../models/artist_data/artist_data.dart';
import '../ui/artist/artist_page.dart';
import '../ui/auth/forgot_password/forgot_password_page.dart';
import '../ui/auth/forgot_password/widgets/change_password/change_password_page.dart';
import '../ui/auth/forgot_password/widgets/verify_otp/verify_forgot_passord_otp_page.dart';
import '../ui/auth/sign_in/signin_page.dart';
import '../ui/auth/sign_up/sign_up_page.dart';
import '../ui/auth/tnc/privacy_policy_page.dart';
import '../ui/auth/tnc/tnc_page.dart';
import '../ui/auth/verify_otp/verify_otp_page.dart';
import '../ui/auth/welcome/welcome_page.dart';
import '../ui/cart/cart_page.dart';
import '../ui/category_tab/category_tab_page.dart';
import '../ui/chat_tab/chat_tab_page.dart';
import '../ui/home_tab/home_tab_page.dart';
import '../ui/main/main_page.dart';
import '../ui/product/product_page.dart';
import '../ui/product_list/product_list_page.dart';
import '../ui/profile_tab/profile_tab_page.dart';
import '../ui/search/search_page.dart';
import '../ui/splash/splash_page.dart';
import '../ui/trending_art/trending_art_list_page.dart';
import '../ui/trending_artist/trending_artist_page.dart';
import '../ui/wishlist/wishlist_page.dart';

part 'router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends _$AppRouter {
  @override
  RouteType get defaultRouteType => const RouteType.cupertino();

  @override
  final List<AutoRoute> routes = [
    AutoRoute(
      path: '/',
      page: SplashRoute.page,
    ),
    CustomRoute(
      path: '/auth',
      page: WelcomeRoute.page,
      transitionsBuilder: (context, animation2, animation, child) =>
          FadeTransition(
        opacity: animation2,
        child: child,
      ),
    ),
    AutoRoute(
      path: '/signin',
      page: SignInRoute.page,
    ),
    AutoRoute(
      path: '/tnc',
      page: TnCRoute.page,
    ),
    AutoRoute(
      path: '/change_password',
      page: ChangePasswordRoute.page,
    ),
    AutoRoute(
      path: '/privacy_plicy',
      page: PrivacyPolicyRoute.page,
    ),
    AutoRoute(
      path: '/signup',
      page: SignUpRoute.page,
    ),
    AutoRoute(
      path: '/veirfy_otp',
      page: VerifyEmailOtpRoute.page,
    ),
    AutoRoute(
      path: '/forgot_password',
      page: ForgotPasswordRoute.page,
    ),
    AutoRoute(
      path: '/verify_pass_otp',
      page: VerifyForgotPasswordOtpRoute.page,
    ),
    AutoRoute(path: '/main', page: MainRoute.page, children: [
      AutoRoute(
        page: HomeTabRoute.page,
        path: "home_tab",
      ),
      AutoRoute(
        page: CategoryTabRoute.page,
        path: "category_tab",
      ),
      AutoRoute(
        page: ProfileTabRoute.page,
        path: "profile_tab",
      ),
      AutoRoute(
        page: ChatTabRoute.page,
        path: "chat_tab",
      ),
    ]),
    AutoRoute(
      path: '/product/:id',
      page: ProductRoute.page,
    ),
    AutoRoute(
      path: '/product-list',
      page: ProductListRoute.page,
    ),
    AutoRoute(
      path: '/cart',
      page: CartRoute.page,
    ),
    AutoRoute(
      path: '/artist',
      page: ArtistRoute.page,
    ),
    AutoRoute(
      path: '/search',
      page: SearchRoute.page,
    ),
    AutoRoute(
      path: '/wishlist',
      page: WishlistRoute.page,
    ),
    AutoRoute(
      path: '/trending_artist_list',
      page: TrendingArtistRoute.page,
    ),
    AutoRoute(
      path: '/trending_art_styles_list',
      page: TrendingArtStylesRoute.page,
    ),
  ];

}
