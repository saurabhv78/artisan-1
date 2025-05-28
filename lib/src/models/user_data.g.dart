// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserData _$UserDataFromJson(Map<String, dynamic> json) => UserData(
      userData:
          UserLoggedData.fromJson(json['userData'] as Map<String, dynamic>),
      token: json['token'] as String,
      time: json['time'] as String,
    );

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
      'userData': instance.userData,
      'token': instance.token,
      'time': instance.time,
    };

UserLoggedData _$UserLoggedDataFromJson(Map<String, dynamic> json) =>
    UserLoggedData(
      fullName: json['full_name'] as String,
      phone: json['phone'] as String?,
      id: json['_id'] as String,
      email: json['email'] as String?,
      profilePic: json['profile_pic'] as String?,
      isEmailVerified: (json['is_email_verified'] as num).toInt(),
      isPhoneVerified: (json['is_phone_verified'] as num).toInt(),
      zipCode: json['zip_code'] as String?,
      fbLink: json['fb_link'] as String?,
      instaLink: json['insta_link'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      loginSource: json['login_source'] as String,
    );

Map<String, dynamic> _$UserLoggedDataToJson(UserLoggedData instance) =>
    <String, dynamic>{
      'full_name': instance.fullName,
      'phone': instance.phone,
      'email': instance.email,
      'profile_pic': instance.profilePic,
      'is_email_verified': instance.isEmailVerified,
      'is_phone_verified': instance.isPhoneVerified,
      'zip_code': instance.zipCode,
      'fb_link': instance.fbLink,
      'insta_link': instance.instaLink,
      'city': instance.city,
      'state': instance.state,
      'login_source': instance.loginSource,
      '_id': instance.id,
    };
