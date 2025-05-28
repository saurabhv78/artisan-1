import 'package:json_annotation/json_annotation.dart';

part 'social_login_request.g.dart';

@JsonSerializable()
class SocialLoginRequest {
  final String email;
  // final String password;
  @JsonKey(name: "fcm_token")
  final String fcmToken;
  final String os;
  @JsonKey(name: "device_id")
  final String deviceId;
  @JsonKey(name: "login_source")
  final String loginSource;
  @JsonKey(name: "auth_token")
  final String? authToken;
  final String? lat;
  final String? lon;
  final String? loction;
  @JsonKey(name: "google_id")
  final String? googleId;
  @JsonKey(name: "fb_uid")
  final String? fbUid;
  @JsonKey(name: "is_email_verified")
  final int isEmailVerified;
  @JsonKey(name: "full_name")
  final String name;

  const SocialLoginRequest({
    required this.email,
    required this.fcmToken,
    this.lat,
    this.lon,
    this.loction,
    this.authToken,
    required this.deviceId,
    this.googleId,
    this.fbUid,
    required this.isEmailVerified,
    required this.loginSource,
    required this.name,
    required this.os,
  });

  factory SocialLoginRequest.fromJson(Map<String, dynamic> json) {
    return _$SocialLoginRequestFromJson(json);
  }
  Map<String, dynamic> toJson() => _$SocialLoginRequestToJson(this);
}
