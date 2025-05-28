// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_email_otp_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendEmailOtpRequest _$SendEmailOtpRequestFromJson(Map<String, dynamic> json) =>
    SendEmailOtpRequest(
      email: json['email'] as String,
      password: json['password'] as String?,
      otp: json['otp'] as String?,
    );

Map<String, dynamic> _$SendEmailOtpRequestToJson(
        SendEmailOtpRequest instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'otp': instance.otp,
    };
