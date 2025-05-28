import 'package:json_annotation/json_annotation.dart';

part 'user_data.g.dart';

@JsonSerializable()
class UserData {
  final UserLoggedData userData;
  final String token;
  final String time;

  UserData({required this.userData, required this.token, required this.time});

  factory UserData.fromJson(Map<String, dynamic> json) {
    return _$UserDataFromJson(json);
  }

  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}

@JsonSerializable()
class UserLoggedData {
  @JsonKey(name: 'full_name')
  final String fullName;
  final String? phone;
  final String? email;
  @JsonKey(name: 'profile_pic')
  final String? profilePic;
  @JsonKey(name: 'is_email_verified')
  final int isEmailVerified;
  @JsonKey(name: 'is_phone_verified')
  final int isPhoneVerified;
  @JsonKey(name: 'zip_code')
  final String? zipCode;
  @JsonKey(name: 'fb_link')
  final String? fbLink;
  @JsonKey(name: 'insta_link')
  final String? instaLink;
  final String? city;
  final String? state;
  @JsonKey(name: "login_source")
  final String loginSource;
  @JsonKey(name: "_id")
  final String id;

  const UserLoggedData({
    required this.fullName,
    this.phone,
    required this.id,
    required this.email,
    this.profilePic,
    required this.isEmailVerified,
    required this.isPhoneVerified,
    this.zipCode,
    this.fbLink,
    this.instaLink,
    this.city,
    this.state,
    required this.loginSource,
  });
  factory UserLoggedData.fromJson(Map<String, dynamic> json) {
    return _$UserLoggedDataFromJson(json);
  }

  Map<String, dynamic> toJson() => _$UserLoggedDataToJson(this);
}
