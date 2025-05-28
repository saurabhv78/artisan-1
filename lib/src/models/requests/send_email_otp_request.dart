import 'package:json_annotation/json_annotation.dart';

part 'send_email_otp_request.g.dart';

@JsonSerializable()
class SendEmailOtpRequest {
  final String email;
  final String? password;
  final String? otp;

  const SendEmailOtpRequest({
    required this.email,
    this.password,
    this.otp,
  });

  factory SendEmailOtpRequest.fromJson(Map<String, dynamic> json) {
    return _$SendEmailOtpRequestFromJson(json);
  }
  Map<String, dynamic> toJson() => _$SendEmailOtpRequestToJson(this);
}
