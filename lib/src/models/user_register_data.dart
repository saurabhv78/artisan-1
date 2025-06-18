import 'package:json_annotation/json_annotation.dart';

part 'user_register_data.g.dart';

@JsonSerializable()
class UserRegisterData {
  final String fullName;
  final String? phone;
  final String email;
  @JsonKey(name: 'profile_pic')
  final String? profilePic;
  @JsonKey(name: 'isEmailVerified')
  final int isEmailVerified;
  @JsonKey(name: 'is_phone_verified')
  final int isPhoneVerified;
  final String password;
  final String confirmPassword;
  @JsonKey(name: 'device_id')
  final String deviceId;
  final String os;
  @JsonKey(name: 'fcm_token')
  final String fcmToken;
  final String loginSource;

  final int? isDefault;

  const UserRegisterData({
    required this.fullName,
    this.phone,
    required this.email,
    this.profilePic,
    required this.isEmailVerified,
    required this.isPhoneVerified,
    required this.password,
    required this.confirmPassword,
    required this.deviceId,
    required this.os,
    required this.fcmToken,
    this.isDefault,
    this.loginSource = 'app',
  });

  factory UserRegisterData.fromJson(Map<String, dynamic> json) {
    return _$UserRegisterDataFromJson(json);
  }
  Map<String, dynamic> toJson() => _$UserRegisterDataToJson(this);
}
