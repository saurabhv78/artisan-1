// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_logout_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserLogoutRequest _$UserLogoutRequestFromJson(Map<String, dynamic> json) =>
    UserLogoutRequest(
      deviceId: json['device_id'] as String,
      id: json['_id'] as String,
    );

Map<String, dynamic> _$UserLogoutRequestToJson(UserLogoutRequest instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'device_id': instance.deviceId,
    };
