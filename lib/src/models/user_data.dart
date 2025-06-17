import 'package:json_annotation/json_annotation.dart';

part 'user_data.g.dart';

@JsonSerializable()
class UserData {
  @JsonKey(name: "user")
  final UserLoggedData userData;
  @JsonKey(name: "access_token")
  final String token;
  @JsonKey(name: "expires_in")
  final String time;

  UserData({required this.userData, required this.token, required this.time});

  factory UserData.fromJson(Map<String, dynamic> json) {
    return _$UserDataFromJson(json);
  }

  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}

@JsonSerializable()
class UserLoggedData {
  final String fullName;
  final String? phone;
  final String? email;
  @JsonKey(name: 'profilePicture')
  final String? profilePic;
  @JsonKey(name: 'is_email_verified')
  final int? isEmailVerified;
  @JsonKey(name: 'is_phone_verified')
  final int? isPhoneVerified;
  @JsonKey(name: 'zip_code')
  final String? zipCode;
  @JsonKey(name: 'fb_link')
  final String? fbLink;
  @JsonKey(name: 'insta_link')
  final String? instaLink;
  final String? city;
  final String? state;
  @JsonKey(name: "login_source")
  final String? loginSource;
  @JsonKey(name: "id")
  final String id;
  @JsonKey(name: "role")
  final String? role;
  final String? createdAt;
  final String? updatedAt;

  const UserLoggedData({
    required this.fullName,
    this.phone,
    required this.id,
    required this.email,
    this.profilePic,
    this.isEmailVerified,
    this.isPhoneVerified,
    this.zipCode,
    this.fbLink,
    this.instaLink,
    this.city,
    this.state,
    this.role,
    this.loginSource = 'app',
    this.createdAt,
    this.updatedAt,
  });
  factory UserLoggedData.fromJson(Map<String, dynamic> json) {
    return _$UserLoggedDataFromJson(json);
  }

  Map<String, dynamic> toJson() => _$UserLoggedDataToJson(this);
}
