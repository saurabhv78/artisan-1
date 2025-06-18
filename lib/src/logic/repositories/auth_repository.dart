import 'dart:async';
import 'dart:io';

import 'package:Artisan/src/models/requests/get_list_data_request.dart';
import 'package:Artisan/src/models/requests/user_logout_request.dart';
import 'package:Artisan/src/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
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
  final StateNotifierProviderRef ref;

  AuthRepository({
    required this.apiService,
    required this.preferenceService,
    required this.ref,
  }) : super(const AuthState()) {
    fetchUserDetails();
  }
  updateUser(UserData? userData) => state =
      state.copyWith(authUser: userData, email: userData?.userData.email);

  fetchUserDetails() async {
    if (!await hasInternetAccess()) {
      showErrorMessage("No Internet Connection");
      state = state.copyWith(status: AuthStatus.unauthenticated);
      return;
    }
    final token = ref
        .read(sharedPreferencesProvider)
        .getString(PreferenceService.authToken);
    if (token == 'guest') {
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
            cartData: res.data!.map((e) => e.prodId.id).toList());
      }
    }
  }

  addWishlist(List<String> wishlist) {
    state = state.copyWith(wishlist: wishlist);
  }

  addCartData(List<String> cartData) {
    state = state.copyWith(cartData: cartData);
  }

  Future<String> logOut() async {
    if (!await hasInternetAccess()) {
      return "No Internet Connection!";
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
      return "";
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
      return e.toString();
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
        GoogleSignIn().disconnect();
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

enum AuthStatus {
  initial,
  unauthenticated,
  authenticatedNotVerified,
  authenticated,
  noInternet,
}
