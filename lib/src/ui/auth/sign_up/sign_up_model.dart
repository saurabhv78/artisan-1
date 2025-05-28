// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:io';

import 'package:Artisan/src/logic/repositories/auth_repository.dart';
import 'package:Artisan/src/models/api_response.dart';
import 'package:Artisan/src/models/user_register_data.dart';
import 'package:Artisan/src/utils/network_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../logic/services/api_services/api_service.dart';

part 'sign_up_model.freezed.dart';

final signUpPageModelProvider =
    StateNotifierProvider.autoDispose<SignUpPageModel, SignUpPageState>(
  (ref) => SignUpPageModel(
    ref: ref,
    apiService: ref.read(apiServiceProvider),
  ),
);

class SignUpPageModel extends StateNotifier<SignUpPageState> {
  final ApiService apiService;
  final StateNotifierProviderRef ref;

  SignUpPageModel({
    required this.apiService,
    required this.ref,
  }) : super(const SignUpPageState());

  setName(String name) => state = state.copyWith(name: name);
  setEmail(String email) => state = state.copyWith(email: email);
  setMobile(String mobile) => state = state.copyWith(mobile: mobile);
  setPassword(String password) => state = state.copyWith(password: password);
  setConfPass(String confPass) =>
      state = state.copyWith(confirmPassword: confPass);

  Future<String> registerUser() async {
    try {
      if (state.name.trim().isEmpty) {
        return 'Please enter full name';
      }
      if (state.email.trim().isEmpty) {
        return 'Please enter email';
      }
      if (state.mobile.trim().isEmpty) {
        return 'Please enter phone number';
      }
      if (state.mobile.trim().length != 10) {
        return 'Invalid phone number';
      }
      if (state.password.trim().length < 6) {
        return 'Please length should be atlest 6';
      }
      if (state.password.trim() != state.confirmPassword.trim()) {
        return 'Password does not match';
      }
      if (!await hasInternetAccess()) {
        return "No Internet Connection";
      }
      String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
      RegExp regex = RegExp(emailPattern);
      if (!regex.hasMatch(state.email)) {
        return "Please enter valid email";
      }
      final deviceId = await getId();
      final res = await apiService.registerUser(
        userData: UserRegisterData(
          fullName: state.name,
          email: state.email,
          password: state.password,
          deviceId: deviceId,
          isDefault: 1,
          isEmailVerified: 0,
          isPhoneVerified: 0,
          os: Platform.isAndroid ? 'android' : 'ios',
          fcmToken: '*',
        ),
      );
      if (res.status != ApiStatus.success) {
        if (mounted) {
          return res.errorMessage ?? "Something Went Wrong";
        }
      } else {
        ref.read(authRepositoryProvider.notifier).setPass(state.password);
        ref.read(authRepositoryProvider.notifier).updateUser(res.data);
        ref.read(authRepositoryProvider.notifier).setCheckBox(true);
        ref
            .read(authRepositoryProvider.notifier)
            .changeState(AuthStatus.authenticatedNotVerified);
        return '';
      }
      return '';
    } catch (e) {
      return e.toString();
    }
  }
}

@freezed
class SignUpPageState with _$SignUpPageState {
  const factory SignUpPageState({
    @Default('') String name,
    @Default('') String email,
    @Default('') String mobile,
    @Default('') String password,
    @Default('') String confirmPassword,
  }) = _SignUpPageState;
}
