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
        print("No internet connection");
        return "No Internet Connection";
      }

      print("Internet connection available");

      // Create a GoogleSignIn instance
      final GoogleSignIn signIn = GoogleSignIn.instance;
      await signIn.initialize(
        serverClientId: Platform.isIOS
            ? "696852379554-4fdea2ptmshsnassad4qvd5b1s1etjcq.apps.googleusercontent.com"
            : "696852379554-i91o5ktaudnci241627rq6i7rj9hnn6v.apps.googleusercontent.com",
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
      String? fcmToken = await FirebaseMessaging.instance.getToken();
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
              fcmToken: fcmToken.toString(),
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

  // Future<void> signInWithAppleTest() async {
  //   try {
  //     final credential = await SignInWithApple.getAppleIDCredential(
  //       scopes: [
  //         AppleIDAuthorizationScopes.email,
  //         AppleIDAuthorizationScopes.fullName,
  //       ],
  //     );

  //     print("User ID: ${credential.userIdentifier}");
  //     print("Email: ${credential.email}");
  //     print("Full Name: ${credential.givenName}");

  //     // You will use credential.identityToken for backend or Firebase
  //   } catch (e) {
  //     print("Apple Signin Error: $e");
  //   }
  // }

  // Future<User?> appleSignInFirebase() async {
  //   try {
  //     final appleCredential = await SignInWithApple.getAppleIDCredential(
  //       scopes: [
  //         AppleIDAuthorizationScopes.email,
  //         AppleIDAuthorizationScopes.fullName,
  //       ],
  //     );
  //     final oauthCredential = OAuthProvider("apple.com").credential(
  //       idToken: appleCredential.identityToken,
  //       accessToken: appleCredential.authorizationCode,
  //     );

  //     return await FirebaseAuth.instance
  //         .signInWithCredential(oauthCredential)
  //         .then((value) {
  //       print("User ID: ${value.user?.uid}");
  //       print("Email: ${value.user?.email}");
  //       print("Full Name: ${value.user?.displayName}");
  //       return value.user;
  //     });
  //   } catch (error) {
  //     print("Apple Sign In Error: $error");
  //     return null;
  //   }
  // }

  // Future<String> signInWithApple(WidgetRef ref) async {
  //   if (!(await hasInternetAccess())) {
  //     return 'No internet connection!';
  //   }

  //   try {
  //     // 1️⃣ Generate nonce
  //     final rawNonce = generateNonce();
  //     final hashedNonce = sha256ofString(rawNonce);

  //     // 2️⃣ Request Apple Credential
  //     final appleCredential = await SignInWithApple.getAppleIDCredential(
  //       scopes: [
  //         AppleIDAuthorizationScopes.email,
  //         AppleIDAuthorizationScopes.fullName,
  //       ],
  //       // nonce: hashedNonce, // REQUIRED
  //     );

  //     // 3️⃣ Firebase Credentials
  //     final oauth = OAuthProvider("apple.com").credential(
  //         idToken: appleCredential.identityToken,
  //         accessToken: appleCredential.authorizationCode
  //         // rawNonce: rawNonce, // REQUIRED
  //         );

  //     final userCredential =
  //         await FirebaseAuth.instance.signInWithCredential(oauth);

  //     final firebaseUser = userCredential.user;

  //     // 4️⃣ Extract email, name, id
  //     final email = firebaseUser?.email ?? appleCredential.email ?? "";
  //     final fullName =
  //         "${appleCredential.givenName ?? ''} ${appleCredential.familyName ?? ''}"
  //             .trim();

  //     final appleUserId = appleCredential.userIdentifier;
  //     if (appleUserId == null) return "Unable to get Apple user ID";

  //     // 5️⃣ Device ID
  //     final deviceId = await getId();

  //     // 6️⃣ Social Login API
  //     final res = await apiService.socialLogin(
  //       socialLoginRequest: SocialLoginRequest(
  //         email: email,
  //         name: fullName.isNotEmpty ? fullName : "Apple User",
  //         deviceId: deviceId,
  //         fcmToken: "*",
  //         loginSource: "apple",
  //       ),
  //     );

  //     if (res.status != ApiStatus.success) {
  //       return res.errorMessage ?? "Something went wrong";
  //     }

  //     // 7️⃣ Update auth provider
  //     ref.read(authRepositoryProvider.notifier).updateUser(res.data);
  //     ref
  //         .read(authRepositoryProvider.notifier)
  //         .setIdToken(res.data?.token ?? "", res.data?.userData.id ?? "");
  //     ref
  //         .read(authRepositoryProvider.notifier)
  //         .changeState(AuthStatus.authenticated);
  //     ref.read(authRepositoryProvider.notifier).getAllUserDetails();

  //     return "";
  //   } catch (e) {
  //     if (e.toString().contains("AuthorizationDenied")) {
  //       return "Apple sign in denied.";
  //     }

  //     if (e.toString().contains("AuthorizationCanceled")) {
  //       return "Apple sign in cancelled.";
  //     }

  //     return "Apple login error: $e";
  //   }
  // }

  // Future<UserCredential> signInWithAppleCred() async {
  //   // To prevent replay attacks with the credential returned from Apple, we
  //   // include a nonce in the credential request. When signing in with
  //   // Firebase, the nonce in the id token returned by Apple, is expected to
  //   // match the sha256 hash of `rawNonce`.
  //   final rawNonce = generateNonce();
  //   final nonce = sha256ofString(rawNonce);

  //   // Request credential for the currently signed in Apple account.
  //   final appleCredential = await SignInWithApple.getAppleIDCredential(
  //     scopes: [
  //       AppleIDAuthorizationScopes.email,
  //       AppleIDAuthorizationScopes.fullName,
  //     ],
  //     nonce: nonce,
  //   );

  //   // Create an `OAuthCredential` from the credential returned by Apple.
  //   final oauthCredential = OAuthProvider("apple.com").credential(
  //     idToken: appleCredential.identityToken,
  //     rawNonce: rawNonce,
  //   );

  //   // Sign in the user with Firebase. If the nonce we generated earlier does
  //   // not match the nonce in `appleCredential.identityToken`, sign in will fail.
  //   final cred =
  //       await FirebaseAuth.instance.signInWithCredential(oauthCredential);
  //   print('Cred: ${cred.user?.email}');
  //   print('Cred: ${cred.user?.displayName}');
  //   return cred;
  // }
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

      await FirebaseAuth.instance.signInWithCredential(oauth);

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
        return "Unable to sign in with Apple. Please try Google or Facebook.";
      }

      return "Unable to sign in with Apple. Please try Google or Facebook.";
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
