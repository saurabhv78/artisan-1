import 'package:json_annotation/json_annotation.dart';

part 'refresh_token_request.g.dart';

@JsonSerializable()
class RefreshTokenRequest {
  @JsonKey(name: "_id")
  final String id;
  final String type;
  RefreshTokenRequest({
    required this.id,
    required this.type,
  });

  factory RefreshTokenRequest.fromJson(Map<String, dynamic> json) {
    return _$RefreshTokenRequestFromJson(json);
  }
  Map<String, dynamic> toJson() => _$RefreshTokenRequestToJson(this);
}
