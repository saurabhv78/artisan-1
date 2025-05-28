// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'social_login_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SocialLoginRequest _$SocialLoginRequestFromJson(Map<String, dynamic> json) =>
    SocialLoginRequest(
      email: json['email'] as String,
      fcmToken: json['fcm_token'] as String,
      lat: json['lat'] as String?,
      lon: json['lon'] as String?,
      loction: json['loction'] as String?,
      authToken: json['auth_token'] as String?,
      deviceId: json['device_id'] as String,
      googleId: json['google_id'] as String?,
      fbUid: json['fb_uid'] as String?,
      isEmailVerified: (json['is_email_verified'] as num).toInt(),
      loginSource: json['login_source'] as String,
      name: json['full_name'] as String,
      os: json['os'] as String,
    );

Map<String, dynamic> _$SocialLoginRequestToJson(SocialLoginRequest instance) =>
    <String, dynamic>{
      'email': instance.email,
      'fcm_token': instance.fcmToken,
      'os': instance.os,
      'device_id': instance.deviceId,
      'login_source': instance.loginSource,
      'auth_token': instance.authToken,
      'lat': instance.lat,
      'lon': instance.lon,
      'loction': instance.loction,
      'google_id': instance.googleId,
      'fb_uid': instance.fbUid,
      'is_email_verified': instance.isEmailVerified,
      'full_name': instance.name,
    };
