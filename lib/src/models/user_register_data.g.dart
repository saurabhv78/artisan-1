// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_register_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserRegisterData _$UserRegisterDataFromJson(Map<String, dynamic> json) =>
    UserRegisterData(
      fullName: json['fullName'] as String,
      phone: json['phone'] as String?,
      email: json['email'] as String,
      profilePic: json['profile_pic'] as String?,
      isEmailVerified: (json['isEmailVerified'] as num).toInt(),
      isPhoneVerified: (json['is_phone_verified'] as num).toInt(),
      password: json['password'] as String,
      confirmPassword: json['confirmPassword'] as String,
      deviceId: json['device_id'] as String,
      os: json['os'] as String,
      fcmToken: json['fcm_token'] as String,
      isDefault: (json['isDefault'] as num?)?.toInt(),
      loginSource: json['loginSource'] as String? ?? 'app',
    );

Map<String, dynamic> _$UserRegisterDataToJson(UserRegisterData instance) =>
    <String, dynamic>{
      'fullName': instance.fullName,
      'phone': instance.phone,
      'email': instance.email,
      'profile_pic': instance.profilePic,
      'isEmailVerified': instance.isEmailVerified,
      'is_phone_verified': instance.isPhoneVerified,
      'password': instance.password,
      'confirmPassword': instance.confirmPassword,
      'device_id': instance.deviceId,
      'os': instance.os,
      'fcm_token': instance.fcmToken,
      'loginSource': instance.loginSource,
      'isDefault': instance.isDefault,
    };
