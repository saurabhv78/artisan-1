// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:async';

import 'package:Artisan/src/models/api_response.dart';
import 'package:Artisan/src/models/requests/send_email_otp_request.dart';
import 'package:Artisan/src/utils/network_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../logic/services/api_services/api_service.dart';

part 'forgot_password_model.freezed.dart';

final forgotPasswordPageModelProvider = StateNotifierProvider.autoDispose<
    ForgotPasswordPageModel, ForgotPasswordPageState>(
  (ref) => ForgotPasswordPageModel(
    ref: ref,
    apiService: ref.read(apiServiceProvider),
  ),
);

class ForgotPasswordPageModel extends StateNotifier<ForgotPasswordPageState> {
  final ApiService apiService;
  final StateNotifierProviderRef ref;

  ForgotPasswordPageModel({
    required this.apiService,
    required this.ref,
  }) : super(const ForgotPasswordPageState());

  setEmail(String email) => state = state.copyWith(email: email);

  setPassword(String password) => state = state.copyWith(password: password);
  setConfPass(String confPass) => state = state.copyWith(confPass: confPass);
  setOtp(String otp) => state = state.copyWith(otp: otp.toString());
  Future<Map<bool, String>> sendChangePasswordOtp() async {
    if (state.email.trim().isEmpty) {
      return {false: "Please enter email"};
    }
    String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp regex = RegExp(emailPattern);
    if (!regex.hasMatch(state.email)) {
      return {false: "Please enter valid email"};
    }
    try {
      if (!await hasInternetAccess()) {
        return {false: "No Internet Connection!"};
      }
      final res = await apiService.sendForgotPassOtp(
        sendEmailOtpRequest: SendEmailOtpRequest(
          email: state.email,
        ),
      );
      if (res.status != ApiStatus.success) {
        return {false: res.errorMessage ?? "Something Went Wrong!"};
      }
      return {
        true: res.data ??
            "Forgot Password Instruction has been sent to your Registered Email Address"
      };
    } catch (e) {
      return {false: e.toString()};
    }
  }

  Future<String> verifyOtp() async {
    if (state.email.trim().isEmpty) {
      return "Please enter email";
    }
    if (state.otp.length != 4) {
      return 'Please enter valid otp';
    }

    try {
      if (!await hasInternetAccess()) {
        return "No Internet Connection!";
      }
      final res = await apiService.verifyOtp(
        sendEmailOtpRequest: SendEmailOtpRequest(
          email: state.email,
          otp: state.otp,
        ),
      );
      if (res.status != ApiStatus.success) {
        return res.errorMessage ?? "Something Went Wrong!";
      }
      return "";
    } catch (e) {
      return e.toString();
    }
  }

  Future<Map<bool, String>> changePassword() async {
    if (state.password.trim().isEmpty) {
      return {false: "Please enter password"};
    }
    if (state.password.trim().length < 6) {
      return {false: 'Password length should be atleast 6'};
    }
    if (state.password.trim() != state.confPass.trim()) {
      return {false: 'Password does not match'};
    }
    try {
      if (!await hasInternetAccess()) {
        return {false: "No Internet Connection!"};
      }
      final res = await apiService.changePassword(
        sendEmailOtpRequest: SendEmailOtpRequest(
          // otp: state.otp,
          password: state.password,
          email: state.email,
        ),
      );
      if (res.status != ApiStatus.success) {
        return {false: res.errorMessage ?? "Something Went Wrong!"};
      } else {
        return {true: res.data ?? "Password Changed Successfully!"};
      }
    } catch (e) {
      return {false: e.toString()};
    }
  }
}

@freezed
class ForgotPasswordPageState with _$ForgotPasswordPageState {
  const factory ForgotPasswordPageState({
    @Default('') String email,
    @Default('') String password,
    @Default('') String otp,
    @Default('') String confPass,
  }) = _ForgotPasswordPageState;
}
