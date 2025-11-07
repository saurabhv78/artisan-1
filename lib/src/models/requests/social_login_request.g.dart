// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'social_login_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SocialLoginRequest _$SocialLoginRequestFromJson(Map<String, dynamic> json) =>
    SocialLoginRequest(
      email: json['email'] as String,
      fcmToken: json['fcmToken'] as String,
      deviceId: json['deviceId'] as String,
      googleId: json['googleId'] as String?,
      loginSource: json['loginSource'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$SocialLoginRequestToJson(SocialLoginRequest instance) =>
    <String, dynamic>{
      'email': instance.email,
      'fcmToken': instance.fcmToken,
      'deviceId': instance.deviceId,
      'loginSource': instance.loginSource,
      'googleId': instance.googleId,
      'name': instance.name,
    };
