// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_register_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserRegisterData _$UserRegisterDataFromJson(Map<String, dynamic> json) =>
    UserRegisterData(
      fullName: json['full_name'] as String,
      phone: json['phone'] as String?,
      email: json['email'] as String,
      profilePic: json['profile_pic'] as String?,
      isEmailVerified: (json['is_email_verified'] as num).toInt(),
      isPhoneVerified: (json['is_phone_verified'] as num).toInt(),
      password: json['password'] as String,
      deviceId: json['device_id'] as String,
      os: json['os'] as String,
      fcmToken: json['fcm_token'] as String,
      isDefault: (json['isDefault'] as num?)?.toInt(),
    );

Map<String, dynamic> _$UserRegisterDataToJson(UserRegisterData instance) =>
    <String, dynamic>{
      'full_name': instance.fullName,
      'phone': instance.phone,
      'email': instance.email,
      'profile_pic': instance.profilePic,
      'is_email_verified': instance.isEmailVerified,
      'is_phone_verified': instance.isPhoneVerified,
      'password': instance.password,
      'device_id': instance.deviceId,
      'os': instance.os,
      'fcm_token': instance.fcmToken,
      'isDefault': instance.isDefault,
    };
