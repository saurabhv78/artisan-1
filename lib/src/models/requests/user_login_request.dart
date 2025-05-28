import 'package:json_annotation/json_annotation.dart';

part 'user_login_request.g.dart';

@JsonSerializable()
class UserLoginRequest {
  final String email;
  final String password;
  @JsonKey(name: "fcm_token")
  final String fcmToken;
  final String os;
  @JsonKey(name: 'device_id')
  final String deviceId;

  const UserLoginRequest({
    required this.email,
    required this.password,
    required this.fcmToken,
    required this.os,
    required this.deviceId,
  });

  factory UserLoginRequest.fromJson(Map<String, dynamic> json) {
    return _$UserLoginRequestFromJson(json);
  }
  Map<String, dynamic> toJson() => _$UserLoginRequestToJson(this);
}
