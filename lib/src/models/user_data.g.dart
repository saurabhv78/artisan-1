// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserData _$UserDataFromJson(Map<String, dynamic> json) => UserData(
      userData: UserLoggedData.fromJson(json['user'] as Map<String, dynamic>),
      token: json['access_token'] as String,
      time: json['expires_in'] as String,
    );

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
      'user': instance.userData,
      'access_token': instance.token,
      'expires_in': instance.time,
    };

UserLoggedData _$UserLoggedDataFromJson(Map<String, dynamic> json) =>
    UserLoggedData(
      fullName: json['fullName'] as String,
      phone: json['phone'] as String?,
      id: json['id'] as String,
      email: json['email'] as String?,
      profilePic: json['profilePicture'] as String?,
      isEmailVerified: (json['isEmailVerified'] as num?)?.toInt(),
      isPhoneVerified: (json['is_phone_verified'] as num?)?.toInt(),
      zipCode: json['zip_code'] as String?,
      fbLink: json['fb_link'] as String?,
      instaLink: json['insta_link'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      role: json['role'] as String?,
      loginSource: json['login_source'] as String? ?? 'app',
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      isGuest: json['isGuest'] as bool? ?? false,
    );

Map<String, dynamic> _$UserLoggedDataToJson(UserLoggedData instance) =>
    <String, dynamic>{
      'fullName': instance.fullName,
      'phone': instance.phone,
      'email': instance.email,
      'profilePicture': instance.profilePic,
      'isEmailVerified': instance.isEmailVerified,
      'is_phone_verified': instance.isPhoneVerified,
      'zip_code': instance.zipCode,
      'fb_link': instance.fbLink,
      'insta_link': instance.instaLink,
      'city': instance.city,
      'state': instance.state,
      'login_source': instance.loginSource,
      'id': instance.id,
      'role': instance.role,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'isGuest': instance.isGuest,
    };
