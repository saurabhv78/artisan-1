import 'package:json_annotation/json_annotation.dart';

part 'fcm_token.g.dart';

@JsonSerializable()
class FcmToken {
  @JsonKey(name: '_id')
  String? id;
  @JsonKey(name: 'device_id')
  String? deviceId;
  @JsonKey(name: 'fcm_token')
  String? fcmToken;
  String? os;

  FcmToken({this.id, this.deviceId, this.fcmToken, this.os});

  factory FcmToken.fromJson(Map<String, dynamic> json) {
    return _$FcmTokenFromJson(json);
  }

  Map<String, dynamic> toJson() => _$FcmTokenToJson(this);
}
