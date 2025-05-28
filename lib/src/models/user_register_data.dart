import 'package:json_annotation/json_annotation.dart';

part 'user_register_data.g.dart';

@JsonSerializable()
class UserRegisterData {
  @JsonKey(name: 'full_name')
  final String fullName;
  final String? phone;
  final String email;
  @JsonKey(name: 'profile_pic')
  final String? profilePic;
  @JsonKey(name: 'is_email_verified')
  final int isEmailVerified;
  @JsonKey(name: 'is_phone_verified')
  final int isPhoneVerified;
  final String password;
  @JsonKey(name: 'device_id')
  final String deviceId;
  final String os;
  @JsonKey(name: 'fcm_token')
  final String fcmToken;

  final int? isDefault;

  const UserRegisterData({
    required this.fullName,
    this.phone,
    required this.email,
    this.profilePic,
    required this.isEmailVerified,
    required this.isPhoneVerified,
    required this.password,
    required this.deviceId,
    required this.os,
    required this.fcmToken,
    this.isDefault,
  });

  factory UserRegisterData.fromJson(Map<String, dynamic> json) {
    return _$UserRegisterDataFromJson(json);
  }
  Map<String, dynamic> toJson() => _$UserRegisterDataToJson(this);
}
