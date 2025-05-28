import 'package:json_annotation/json_annotation.dart';

part 'user_logout_request.g.dart';

@JsonSerializable()
class UserLogoutRequest {
  @JsonKey(name: '_id')
  final String id;
  @JsonKey(name: 'device_id')
  final String deviceId;

  const UserLogoutRequest({
    required this.deviceId,
    required this.id,
  });

  factory UserLogoutRequest.fromJson(Map<String, dynamic> json) {
    return _$UserLogoutRequestFromJson(json);
  }
  Map<String, dynamic> toJson() => _$UserLogoutRequestToJson(this);
}
