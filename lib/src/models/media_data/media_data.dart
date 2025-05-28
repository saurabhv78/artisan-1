import 'package:json_annotation/json_annotation.dart';

part 'media_data.g.dart';

@JsonSerializable()
class MediaData {
  @JsonKey(name: '_id')
  final String id;
  final String fileName;
  final String mimeType;

  MediaData({
    required this.id,
    required this.fileName,
    required this.mimeType,
  });

  factory MediaData.fromJson(Map<String, dynamic> json) {
    return _$MediaDataFromJson(json);
  }

  Map<String, dynamic> toJson() => _$MediaDataToJson(this);
}
