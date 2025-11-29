import 'dart:async';
import 'dart:io';

import 'package:Artisan/src/models/requests/get_list_data_request.dart';
import 'package:Artisan/src/routing/router.dart';
import 'package:Artisan/src/utils/toast_utils.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../models/api_response.dart';
import '../../models/requests/user_login_request.dart';
import '../../models/user_data.dart';

import '../../utils/network_utils.dart';
import '../services/api_services/api_service.dart';
import '../services/preference_services.dart';

part 'auth_repository.freezed.dart';

final authRepositoryProvider = StateNotifierProvider<AuthRepository, AuthState>(
  (ref) => AuthRepository(
    apiService: ref.read(apiServiceProvider),
    preferenceService: ref.read(preferenceServiceProvider),
    ref: ref,
  ),
);

class AuthRepository extends StateNotifier<AuthState> {
  final ApiService apiService;
  late final StreamSubscription _subscription;
  final PreferenceService preferenceService;
  final Ref ref;

  AuthRepository({
    required this.apiService,
    required this.preferenceService,
    required this.ref,
  }) : super(const AuthState()) {
    fetchUserDetails();
  }
  AuthState updateUser(UserData? userData) => state =
      state.copyWith(authUser: userData, email: userData?.userData.email);

  Future<void> fetchUserDetails() async {
    if (!await hasInternetAccess()) {
      showErrorMessage("No Internet Connection");
      state = state.copyWith(status: AuthStatus.unauthenticated);
      return;
    }
    final token = ref
        .read(sharedPreferencesProvider)
        .getString(PreferenceService.authToken);
    if (token?.toLowerCase() == 'guest') {
      loginAsGuest();
      return;
    }
    if (token == null || token.isEmpty) {
      state = state.copyWith(status: AuthStatus.unauthenticated);
      return;
    } else {
      debugPrint('token $token');
      final res = await apiService.fetchUserDetails(token: token);
      if (res.status != ApiStatus.success) {
        final id = ref
            .read(sharedPreferencesProvider)
            .getString(PreferenceService.userId);
        if (id == null || id.isEmpty) {
          state = state.copyWith(status: AuthStatus.unauthenticated);
          return;
        }
        // final response =
        //     await apiService.refreshToken(userId: id, type: 'auth');
        // if (response.status != ApiStatus.success) {
        //   state = state.copyWith(status: AuthStatus.unauthenticated);
        //   setIdToken('', '');
        //   return;
        // }
        // setIdToken(response.data!, id);
        // fetchUserDetails();
        return;
      } else {
        state = state.copyWith(
            authUser: UserData(userData: res.data!, token: token, time: '24h'));
        setIdToken(token, res.data!.id);
        state = state.copyWith(status: AuthStatus.authenticated);
        getAllUserDetails();
      }
    }
  }

  Future<Map<bool, String>> updateFav(String productId) async {
    if (!await hasInternetAccess()) {
      return {false: 'No Internet Connection!'};
    }
    final token = ref
        .read(sharedPreferencesProvider)
        .getString(PreferenceService.authToken);
    if (token == null || token.isEmpty) {
      return {false: 'Auth Error. Login again!'};
    }
    try {
      final res = await apiService.updateFav(
          token: token,
          getListDataRequest: GetListDataRequest(updateFavProdId: productId));
      if (res.status != ApiStatus.success || res.data == null) {
        return {false: res.errorMessage ?? "Something Went Wrong"};
      }
      return {true: res.data!};
    } catch (e) {
      return {false: e.toString()};
    }
  }

  Future<void> getWishlist() async {
    final token = ref
        .read(sharedPreferencesProvider)
        .getString(PreferenceService.authToken);
    if (token == null || token.isEmpty) {
      return;
    }
    final res = await ref.read(apiServiceProvider).getAllFav(token: token);
    if (res.status != ApiStatus.success && res.data != null) {
      return;
    } else {
      if (mounted) {
        state = state.copyWith(wishlist: res.data!.map((e) => e.id).toList());
      }
    }
  }

  Future<void> getCartData() async {
    final token = ref
        .read(sharedPreferencesProvider)
        .getString(PreferenceService.authToken);
    if (token == null || token.isEmpty) {
      return;
    }
    final res = await ref.read(apiServiceProvider).getAllCart(token: token);
    if (res.status != ApiStatus.success && res.data != null) {
      return;
    } else {
      if (mounted) {
        state = state.copyWith(
            cartData:
                res.data!.items.map((e) => e.id).whereType<String>().toList());
      }
    }
  }

  addWishlist(List<String> wishlist) {
    state = state.copyWith(wishlist: wishlist);
  }

  addCartData(List<String> cartData) {
    state = state.copyWith(cartData: cartData);
  }

  Future<(bool, String?)> logOut() async {
    if (!await hasInternetAccess()) {
      return (false, "No Internet Connection!");
    }
    try {
      final deviceId = await getId();
      /* final res = await apiService.logOut(
          userLogoutRequest: UserLogoutRequest(
              deviceId: deviceId, id: state.authUser?.userData.id ?? ""));
      if (res.status != ApiStatus.success) {
        return res.errorMessage ?? "Something Went Wrong!!!";
      } */
      setIdToken("", "");

      // GoogleSignIn().disconnect();
      state = state.copyWith(
          authUser: null,
          status: AuthStatus.unauthenticated,
          email: null,
          wishlist: [],
          cartData: [],
          password: null);
      GoogleSignIn.instance.disconnect();
      return (true, "");
    } catch (e) {
      state = state.copyWith(
          authUser: null,
          status: AuthStatus.unauthenticated,
          email: null,
          cartData: [],
          wishlist: [],
          password: null);
      setIdToken('', '');
      // GoogleSignIn().disconnect();
      changeState(AuthStatus.unauthenticated);
      return (false, e.toString());
    }
  }

  setIdToken(String token, String userId) {
    ref
        .read(sharedPreferencesProvider)
        .setString(PreferenceService.authToken, token);
    ref
        .read(sharedPreferencesProvider)
        .setString(PreferenceService.userId, userId);
  }

  getAllUserDetails() async {
    try {
      await getWishlist();
      await getCartData();
    } catch (e) {}
  }

  Future<void> _refreshToken() async {
    //TODO: add refresh token feature
  }

  Future<String> loginAsGuest() async {
    final user = UserData.guest();
    updateUser(user);
    setIdToken(user.token, user.userData.id);
    changeState(AuthStatus.authenticated);
    return '';
  }

  Future<String> loginUser() async {
    try {
      if (!await hasInternetAccess()) {
        return "No Internet Connection";
      }
      String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
      RegExp regex = RegExp(emailPattern);
      if (!regex.hasMatch(state.email ?? "")) {
        return "Please enter valid email";
      }
      final deviceId = await getId();
      final res = await apiService.loginUser(
          userLoginRequest: UserLoginRequest(
              email: state.email!,
              password: state.password!,
              fcmToken: '*',
              deviceId: deviceId,
              os: Platform.isAndroid ? 'android' : "ios"));

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
        state = state.copyWith(authUser: res.data);
        if (state.checkbox) {
          setIdToken(res.data?.token ?? "", res.data?.userData.id ?? "");
        }
        if (res.data?.userData.isEmailVerified == 1) {
          changeState(AuthStatus.authenticated);
        } else {
          changeState(AuthStatus.authenticatedNotVerified);
        }
        getAllUserDetails();
        return '';
      }

      return '';
    } catch (e) {
      setIdToken("", "");
      try {
        GoogleSignIn.instance.disconnect();
      } catch (e) {
        // return e.toString()
      }

      return e.toString();
    }
  }

  // signOut() {
  //   state = state.copyWith(
  //     status: AuthStatus.unauthenticated,
  //     authUser: null,
  //     idToken: null,
  //   );
  // }

  setInternetConnectedStatus() {
    state = state.copyWith(
      status: state.idToken != null
          ? AuthStatus.authenticated
          : AuthStatus.unauthenticated,
    );
  }

  setEmail(String email) => state = state.copyWith(email: email);
  setPass(String pass) => state = state.copyWith(password: pass);
  setCheckBox(bool checkbox) => state = state.copyWith(checkbox: checkbox);
  changeState(AuthStatus authStatus) {
    state = state.copyWith(status: authStatus);
  }

  void showLoginPopUp(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        // Logout डायलॉग से स्टाइल कॉपी करें
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        // 'Logout' की जगह 'Login Required' टाइटल
        title: Row(
          children: [
            // Icon को बदलें (उदा. 'person' या 'lock_open')
            const Icon(Icons.lock_open, color: Colors.redAccent),
            const SizedBox(width: 10),
            Text(
              'Login Required',
              style: GoogleFonts.nunitoSans(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        // कंटेंट बदलें
        content: Text(
          'You need to log in to access this feature.',
          style: GoogleFonts.nunitoSans(fontSize: 16),
        ),
        // एक्शन बटन और स्टाइल
        actionsAlignment: MainAxisAlignment.end,
        actionsPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context)
                .pop(), // Pop with no value (implicitly false)
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey[700],
            ),
            child: Text(
              'Cancel',
              style: GoogleFonts.nunitoSans(fontSize: 15),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              logOut();
              // Navigator.of(context)
              //     .pop(true); // Pop with true to indicate 'Login' was pressed
              // // Login स्क्रीन पर नेविगेट करें
              // context.replaceRoute(const SignInRoute());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent, // कलर बदलें
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Login',
              style: GoogleFonts.nunitoSans(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
  }
}

@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    @Default(null) UserData? authUser,
    @Default(null) String? idToken,
    @Default(null) String? email,
    @Default(null) String? password,
    @Default(false) bool checkbox,
    @Default([]) List<String> wishlist,
    @Default([]) List<String> cartData,
    @Default(AuthStatus.initial) AuthStatus status,
  }) = _AuthState;
}

extension AuthStateX on AuthState {
  bool get isGuest => authUser?.userData.isGuest == true;
}

enum AuthStatus {
  initial,
  unauthenticated,
  authenticatedNotVerified,
  authenticated,
  noInternet,
}
