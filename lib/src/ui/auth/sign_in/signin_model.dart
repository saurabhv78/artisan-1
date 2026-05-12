import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:Artisan/src/logic/repositories/auth_repository.dart';
import 'package:Artisan/src/models/api_response.dart';
import 'package:Artisan/src/models/requests/social_login_request.dart';
import 'package:Artisan/src/models/requests/user_login_request.dart';
import 'package:Artisan/src/utils/network_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart'
    show FirebaseMessaging;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../../logic/services/api_services/api_service.dart';

import 'package:crypto/crypto.dart';
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
        return "No internet connection. Please check and try again.";
      }
      final google = GoogleSignIn.instance;
      await google.initialize();

      // 1️⃣ Trigger Google Sign-In
      final GoogleSignInAccount googleUser = await google.authenticate();

/*       // 2️⃣ Obtain auth details
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      // 3️⃣ Create Firebase credential
      final credential = GoogleAuthProvider.credential(
        // accessToken: googleAuth.,
        idToken: googleAuth.idToken,
      );

      // 4️⃣ Firebase sign-in
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      final firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        return "Google login failed. Please try again.";
      } */

      // // 5️⃣ Get Firebase ID Token (send THIS to backend)
      // final firebaseIdToken = await firebaseUser.getIdToken();

      final fcmToken = await FirebaseMessaging.instance.getToken();
      final deviceId = await getId();

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

      if (res.status != ApiStatus.success) {
        return res.errorMessage ?? "Unable to login. Please try again.";
      }

      ref.read(authRepositoryProvider.notifier).updateUser(res.data);
      ref.read(authRepositoryProvider.notifier).setIdToken(
            res.data?.token ?? "",
            res.data?.userData.id ?? "",
          );

      ref
          .read(authRepositoryProvider.notifier)
          .changeState(AuthStatus.authenticated);

      ref.read(authRepositoryProvider.notifier).getAllUserDetails();

      return '';
    } catch (e, st) {
      final error = e.toString();
      print("Google Sign-in Error: $error");
      print("Google Sign-in Error Stack Trace: $st");

      if (error.contains("sign_in_canceled") ||
          error.contains("User canceled") ||
          error.contains("popup_closed")) {
        return "Google sign-in cancelled.";
      }

      if (error.contains("network_error")) {
        return "Network error — please check your connection.";
      }

      if (error.contains("access_denied") || error.contains("authorization")) {
        return "Google login was denied. Please try again.";
      }

      if (error.contains("invalid_client") ||
          error.contains("misconfigured") ||
          error.contains("developer_error")) {

        return "Google login unavailable at the moment.";
        
      }

      return "Unable to sign in. Please try again.";
    }
  }

  addInd(int ind) {
    state = state.copyWith(removedInd: state.removedInd.toList()..add(ind));
  }

  Future<String> signInWithFacebook(WidgetRef ref) async {
    if (!(await hasInternetAccess())) {
      return "No internet connection! Please try again.";
    }

    try {
      // Ensure no previous FB session conflict
      await FacebookAuth.instance.logOut();

      final String? fcmToken = await FirebaseMessaging.instance.getToken();

      // Start Facebook Login
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      // --- SUCCESS CASE ---
      if (result.status == LoginStatus.success) {
        final userData = await FacebookAuth.instance.getUserData();
        final String? email = userData['email'];
        final String name = userData['name'] ?? "Facebook User";
        final String deviceId = await getId();

        if (email == null || email.isEmpty) {
          return "Unable to fetch email from Facebook.";
        }

        final res = await apiService.socialLogin(
          socialLoginRequest: SocialLoginRequest(
            email: email,
            fcmToken: fcmToken ?? "",
            deviceId: deviceId,
            loginSource: 'facebook',
            name: name,
          ),
        );

        if (res.status != ApiStatus.success) {
          return res.errorMessage ?? "Unable to login with Facebook.";
        }

        ref.read(authRepositoryProvider.notifier).updateUser(res.data);
        ref.read(authRepositoryProvider.notifier).setIdToken(
              res.data?.token ?? "",
              res.data?.userData.id ?? "",
            );
        ref
            .read(authRepositoryProvider.notifier)
            .changeState(AuthStatus.authenticated);
        ref.read(authRepositoryProvider.notifier).getAllUserDetails();

        return "";
      }

      // --- CANCELLED CASE ---
      else if (result.status == LoginStatus.cancelled) {
        return "Facebook sign-in cancelled.";
      }

      // --- FAILED WITH MESSAGE FROM FB SDK ---
      else if (result.status == LoginStatus.failed) {
        final msg = result.message ?? "";

        if (msg.contains("denied") || msg.contains("permission")) {
          return "Facebook login permission denied.";
        }

        return "Unable to login with Facebook. Please try again.";
      }

      // Fallback for unknown states
      return "Unable to login with Facebook.";
    } catch (e) {
      final error = e.toString();

      if (error.contains("network") || error.contains("internet")) {
        return "Network error — please check your connection.";
      }

      if (error.contains("invalid_key") ||
          error.contains("appsecret") ||
          error.contains("developer_error") ||
          error.contains("misconfigured")) {
        return "Facebook login unavailable at the moment.";
      }

      return "Something went wrong. Please try again.";
    }
  }

  Future<String> signInWithApple(WidgetRef ref) async {
    try {
      if (!(await hasInternetAccess())) {
        return "No internet connection!";
      }

      final rawNonce = generateNonce();
      final hashedNonce = sha256ofString(rawNonce);

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: hashedNonce,
      );

      final oauth = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(oauth);
      final firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        return "Apple login failed. Please try again.";
      }

      final fcmToken = await FirebaseMessaging.instance.getToken();
      final deviceId = await getId();

      final res = await apiService.socialLogin(
        socialLoginRequest: SocialLoginRequest(
          email: firebaseUser.email ?? "",
          fcmToken: fcmToken ?? "",
          deviceId: deviceId,
          loginSource: 'apple',
          name: firebaseUser.displayName ?? "Apple User",
        ),
      );

      if (res.status != ApiStatus.success) {
        return res.errorMessage ?? "Unable to login with Apple.";
      }

      ref.read(authRepositoryProvider.notifier).updateUser(res.data);
      ref.read(authRepositoryProvider.notifier).setIdToken(
            res.data?.token ?? "",
            res.data?.userData.id ?? "",
          );

      ref
          .read(authRepositoryProvider.notifier)
          .changeState(AuthStatus.authenticated);

      ref.read(authRepositoryProvider.notifier).getAllUserDetails();

      return ""; // success
    } catch (e) {
      print("APPLE LOGIN ERROR → $e");

      // Specific Apple Errors
      if (e.toString().contains("AuthorizationCanceled")) {
        return "Apple sign-in cancelled.";
      }

      if (e.toString().contains("AuthorizationDenied")) {
        return "Apple sign-in denied.";
      }

      // Firebase / App Check / OAuth
      if (e.toString().contains("invalid-credential") ||
          e.toString().contains("AppCheck") ||
          e.toString().contains("PERMISSION_DENIED") ||
          e.toString().contains("403") ||
          e.toString().contains("App attestation failed")) {
        return "Apple Login Could Not Be Verified, you may still retry with Apple to create or access your Apple-linked account or Log in with Google/Facebook to login into your account.";
      }

      return "Apple Login Could Not Be Verified because the email linked to this Apple account is private or does not match an existing account.You may still retry with Apple to create or access your Apple-linked accountorLog in with Google/Facebook to connect your existing account.";
    }
  }

  /// Generates a cryptographically secure random nonce, to be included in a
  /// credential request.
  String generateNonce([int length = 32]) {
    final charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
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
