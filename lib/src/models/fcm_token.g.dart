// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fcm_token.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FcmToken _$FcmTokenFromJson(Map<String, dynamic> json) => FcmToken(
      id: json['_id'] as String?,
      deviceId: json['device_id'] as String?,
      fcmToken: json['fcm_token'] as String?,
      os: json['os'] as String?,
    );

Map<String, dynamic> _$FcmTokenToJson(FcmToken instance) => <String, dynamic>{
      '_id': instance.id,
      'device_id': instance.deviceId,
      'fcm_token': instance.fcmToken,
      'os': instance.os,
    };
