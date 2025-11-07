import 'dart:io';
import 'package:Artisan/src/logic/repositories/auth_repository.dart';
import 'package:Artisan/src/models/api_response.dart';
import 'package:Artisan/src/models/requests/social_login_request.dart';
import 'package:Artisan/src/models/requests/user_login_request.dart';
import 'package:Artisan/src/utils/network_utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart'
    show FirebaseMessaging;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';
import '../../../logic/services/api_services/api_service.dart';
part 'signin_model.freezed.dart';

final signInPageModelProvider =
    StateNotifierProvider.autoDispose<SignInPageModel, SignInPageState>(
  (ref) => SignInPageModel(
    ref: ref,
    apiService: ref.read(apiServiceProvider),
  ),
);

class SignInPageModel extends StateNotifier<SignInPageState> {
  final ApiService apiService;
  final StateNotifierProviderRef ref;

  SignInPageModel({
    required this.apiService,
    required this.ref,
  }) : super(const SignInPageState());

  setEmail(String email) => state = state.copyWith(email: email);

  setPassword(String password) => state = state.copyWith(password: password);

  Future<String> loginUser(
      {required bool checkBox, String? email, String? password}) async {
    try {
      if (!await hasInternetAccess()) {
        return "No Internet Connection";
      }
      String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
      RegExp regex = RegExp(emailPattern);
      if (!regex.hasMatch(state.email)) {
        return "Please enter valid email";
      }
      String? fcmToken = await FirebaseMessaging.instance.getToken();
      final deviceId = await getId();
      final res = await apiService.loginUser(
          userLoginRequest: UserLoginRequest(
              email: email ?? state.email,
              password: password ?? state.password,
              fcmToken: fcmToken.toString(),
              deviceId: deviceId,
              os: Platform.isAndroid ? 'android' : "ios"));
      ref.read(authRepositoryProvider.notifier).setEmail(state.email);
      ref.read(authRepositoryProvider.notifier).setPass(state.password);
      if (res.status != ApiStatus.success) {
        if (mounted) {
          if (res.errorMessage == 'Email not verified') {
            ref
                .read(authRepositoryProvider.notifier)
                .changeState(AuthStatus.authenticatedNotVerified);
            return "";
          }
          return res.errorMessage ?? "Something Went Wrong";
        }
      } else {
        ref.read(authRepositoryProvider.notifier).updateUser(res.data);
        if (checkBox) {
          ref
              .read(authRepositoryProvider.notifier)
              .setIdToken(res.data?.token ?? "", res.data?.userData.id ?? "");
        }
        if (res.data?.userData.isEmailVerified == 1) {
          ref
              .read(authRepositoryProvider.notifier)
              .changeState(AuthStatus.authenticated);
          ref.read(authRepositoryProvider.notifier).getAllUserDetails();
        } else {
          ref
              .read(authRepositoryProvider.notifier)
              .changeState(AuthStatus.authenticatedNotVerified);
        }
        return '';
      }

      return '';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> signinWithGoogle() async {
    try {
      print("Starting Google Sign-in process");

      if (!await hasInternetAccess()) {
        print("No internet connection");
        return "No Internet Connection";
      }

      print("Internet connection available");

      // Create a GoogleSignIn instance
      final GoogleSignIn signIn = GoogleSignIn.instance;
      await signIn.initialize(
        serverClientId:
            "696852379554-i91o5ktaudnci241627rq6i7rj9hnn6v.apps.googleusercontent.com",
      );

      print("Fetching FCM token");
      final fcmToken = await FirebaseMessaging.instance.getToken();
      print("FCM token: $fcmToken");

      print("Starting Google authentication");
      final GoogleSignInAccount googleUser = await signIn.authenticate();

      print("Google account email: ${googleUser.email}");

      print("Fetching device ID");
      final deviceId = await getId();
      print("Device ID: $deviceId");

      print("Sending social login API request");
      final res = await apiService.socialLogin(
        socialLoginRequest: SocialLoginRequest(
          email: googleUser.email,
          fcmToken: fcmToken ?? "",
          deviceId: deviceId,
          googleId: googleUser.id,
          loginSource: 'google',
          name: googleUser.displayName ?? "",
        ),
      );

      print("API response status: ${res.status}");
      if (res.status != ApiStatus.success) {
        print("API error message: ${res.errorMessage}");
        return res.errorMessage ?? "Something Went Wrong";
      }

      print("Updating user and setting tokens");
      ref.read(authRepositoryProvider.notifier).updateUser(res.data);
      ref.read(authRepositoryProvider.notifier).setIdToken(
            res.data?.token ?? "",
            res.data?.userData.id ?? "",
          );

      ref
          .read(authRepositoryProvider.notifier)
          .changeState(AuthStatus.authenticated);
      ref.read(authRepositoryProvider.notifier).getAllUserDetails();

      print("Google Sign-in completed successfully");
      return '';
    } catch (e, stackTrace) {
      print("Exception during Google Sign-in: $e");
      print("StackTrace: $stackTrace");
      return e.toString();
    }
  }

  addInd(int ind) {
    state = state.copyWith(removedInd: state.removedInd.toList()..add(ind));
  }

  // Future<void> _updateLoginInfo(FacebookLogin plugin) async {
  //   final token = await plugin.accessToken;
  //   FacebookUserProfile? profile;
  //   String? email;
  //   String? imageUrl;

  //   if (token != null) {
  //     profile = await plugin.getUserProfile();
  //     if (token.permissions.contains(FacebookPermission.email.name)) {
  //       email = await plugin.getUserEmail();
  //     }
  //     imageUrl = await plugin.getProfileImageUrl(width: 100);
  //   }
  //   print(email);
  // }

  // Future<String> signInWithFacebook() async {
  //   // return
  //   // "Feature Disabled by Admin";
  //   if (!(await hasInternetAccess())) {
  //     return 'No internet connection!';
  //   }
  //   try {
  //     final plugin = FacebookLogin(debug: true);
  //     try {
  //       await plugin.logOut();
  //       // plugin.
  //     } catch (e) {}
  //     await plugin.logIn(permissions: [
  //       FacebookPermission.publicProfile,
  //       FacebookPermission.email,
  //     ]);
  //     final deviceId = await getId();
  //     final profile = await plugin.getUserProfile();
  //     final email = await plugin.getUserEmail();
  //     final token = await plugin.accessToken;
  //     if (email != null && email.isNotEmpty && profile != null) {
  //       final res = await apiService.socialLogin(
  //         socialLoginRequest: SocialLoginRequest(
  //           email: email,
  //           fcmToken: '*',
  //           deviceId: deviceId,
  //           // loction: 'Social Test Address',
  //           // lat: "23.2",
  //           // lon: '33.2',
  //           // fbUid: profile.userId,
  //           // authToken: token?.authenticationToken ?? "facebook",
  //           // isEmailVerified: 1,
  //           loginSource: 'facebook',
  //           name: profile.name ?? "Facebook User",
  //           // os: Platform.isAndroid ? 'android' : 'ios',
  //         ),
  //       );
  //       if (res.status != ApiStatus.success) {
  //         return res.errorMessage ?? "Something Went Wrong";
  //       }
  //       if (mounted) {
  //         ref.read(authRepositoryProvider.notifier).updateUser(res.data);
  //         ref
  //             .read(authRepositoryProvider.notifier)
  //             .setIdToken(res.data?.token ?? "", res.data?.userData.id ?? "");
  //         ref
  //             .read(authRepositoryProvider.notifier)
  //             .changeState(AuthStatus.authenticated);
  //         ref.read(authRepositoryProvider.notifier).getAllUserDetails();
  //       }

  //       return '';
  //     } else {
  //       return "Something Went Wrong!!!";
  //     }
  //   } catch (e) {
  //     return e.toString();
  //   }
  // }
  Future<String> signInWithFacebook(WidgetRef ref) async {
    if (!(await hasInternetAccess())) {
      return 'No internet connection!';
    }

    try {
      // Log out any existing Facebook session
      await FacebookAuth.instance.logOut();

      // Trigger login
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      if (result.status == LoginStatus.success) {
        final accessToken = result.accessToken;
        final userData = await FacebookAuth.instance.getUserData();

        final email = userData['email'];
        final name = userData['name'];
        final fbUid = userData['id'];
        final deviceId = await getId();

        if (email != null && email.isNotEmpty) {
          final res = await apiService.socialLogin(
            socialLoginRequest: SocialLoginRequest(
              email: email,
              fcmToken: '*',
              deviceId: deviceId,
              loginSource: 'facebook',
              name: name ?? "Facebook User",
            ),
          );

          if (res.status != ApiStatus.success) {
            return res.errorMessage ?? "Something went wrong";
          }

          ref.read(authRepositoryProvider.notifier).updateUser(res.data);
          ref
              .read(authRepositoryProvider.notifier)
              .setIdToken(res.data?.token ?? "", res.data?.userData.id ?? "");
          ref
              .read(authRepositoryProvider.notifier)
              .changeState(AuthStatus.authenticated);
          ref.read(authRepositoryProvider.notifier).getAllUserDetails();

          return '';
        } else {
          return "Failed to get email from Facebook.";
        }
      } else if (result.status == LoginStatus.cancelled) {
        return "Login cancelled by user.";
      } else {
        return result.message ?? "Facebook login failed.";
      }
    } catch (e) {
      return "Facebook login error: $e";
    }
  }

  Future<String> signInWithApple({List<Scope> scopes = const []}) async {
    if (!(await hasInternetAccess())) {
      return 'No internet connection!';
    }

    // state = state.copyWith(
    //   status: AuthPageStatus.authenticatingWithApple,
    // );
    final result = await TheAppleSignIn.performRequests(
        [AppleIdRequest(requestedScopes: scopes)]);
    try {
      switch (result.status) {
        case AuthorizationStatus.authorized:
          // final appleIdCredential = result.credential!;

          return '';
        case AuthorizationStatus.error:
          // state = state.copyWith(
          //   status: AuthPageStatus.error,
          // );
          return 'ERROR_AUTHORIZATION_DENIED';

        case AuthorizationStatus.cancelled:
          // state = state.copyWith(
          //   status: AuthPageStatus.error,
          // );
          return 'Sign in aborted by user';

        default:
          return 'Authentication Failed';
      }
    } catch (e) {
      return e.toString();
    }
  }
}

@freezed
class SignInPageState with _$SignInPageState {
  const factory SignInPageState({
    @Default('') String email,
    @Default('') String password,
    @Default([]) List<int> removedInd,
  }) = _SignInPageState;
}
