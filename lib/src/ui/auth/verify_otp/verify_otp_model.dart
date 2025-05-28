// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:async';

import 'package:Artisan/src/logic/repositories/auth_repository.dart';
import 'package:Artisan/src/models/api_response.dart';
import 'package:Artisan/src/models/requests/send_email_otp_request.dart';
import 'package:Artisan/src/utils/network_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../logic/services/api_services/api_service.dart';

part 'verify_otp_model.freezed.dart';

final verifyOtpPageModelProvider =
    StateNotifierProvider.autoDispose<VerifyOtpPageModel, VerifyOtpPageState>(
  (ref) => VerifyOtpPageModel(
    ref: ref,
    apiService: ref.read(apiServiceProvider),
  ),
);

class VerifyOtpPageModel extends StateNotifier<VerifyOtpPageState> {
  final ApiService apiService;
  final StateNotifierProviderRef ref;

  VerifyOtpPageModel({
    required this.apiService,
    required this.ref,
  }) : super(const VerifyOtpPageState());

  setEmail(String email) => state = state.copyWith(email: email);

  setPassword(String password) => state = state.copyWith(password: password);
  setOtp(String otp) => state = state.copyWith(otp: otp.toString());
  Future<String> sendEmailOtp() async {
    if (ref.read(authRepositoryProvider.select((value) => value.email)) == '') {
      return "Please Enter Email";
    }
    try {
      if (!await hasInternetAccess()) {
        return "No Internet Connection!";
      }
      final res = await apiService.sendOtp(
          sendEmailOtpRequest: SendEmailOtpRequest(
              email: ref.read(
                  authRepositoryProvider.select((value) => value.email!))));
      if (res.status != ApiStatus.success) {
        return res.errorMessage ?? "Something Went Wrong!";
      } else {
        debugPrint(res.data);
      }
      return "";
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> updateEmailOtp() async {
    if (ref.read(authRepositoryProvider.select((value) => value.email)) == '') {
      return "Please Enter Email";
    }
    try {
      if (state.otp.length != 4) {
        return 'Please enter valid otp';
      }
      if (!await hasInternetAccess()) {
        return "No Internet Connection!";
      }
      final res = await apiService.updateEmailOtp(
          sendEmailOtpRequest: SendEmailOtpRequest(
              otp: state.otp,
              email: ref.read(
                  authRepositoryProvider.select((value) => value.email!))));
      if (res.status != ApiStatus.success) {
        return res.errorMessage ?? "Something Went Wrong!";
      } else {
        debugPrint(res.data);
        await ref.read(authRepositoryProvider.notifier).loginUser();
      }
      return "";
    } catch (e) {
      return e.toString();
    }
  }
}

@freezed
class VerifyOtpPageState with _$VerifyOtpPageState {
  const factory VerifyOtpPageState({
    @Default('') String email,
    @Default('') String password,
    @Default('') String otp,
  }) = _VerifyOtpPageState;
}
