import 'package:json_annotation/json_annotation.dart';

part 'art_style_data.g.dart';

@JsonSerializable()
class ArtStyleResponse {
  final bool success;
  final String message;
  final int statusCode;
  final List<ArtStyle> data;
  final OtherMeta other;

  ArtStyleResponse({
    required this.success,
    required this.message,
    required this.statusCode,
    required this.data,
    required this.other,
  });

  factory ArtStyleResponse.fromJson(Map<String, dynamic> json) =>
      _$ArtStyleResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ArtStyleResponseToJson(this);
}

@JsonSerializable()
class ArtStyle {
  final String id;
  final String? name;
  final String? file;

  ArtStyle({
     this.id = '',
     this.name,
     this.file,
  });

  factory ArtStyle.fromJson(Map<String, dynamic> json) =>
      _$ArtStyleFromJson(json);

  Map<String, dynamic> toJson() => _$ArtStyleToJson(this);
}

@JsonSerializable()
class OtherMeta {
  final int? page;
  final int? limit;
  final int? skip;
  final String? sort;
  final String? sortDirection;
  final int? totalPages;
  final int? total;

  OtherMeta({
    this.page,
    this.limit,
    this.skip,
    this.sort,
    this.sortDirection,
    this.totalPages,
    this.total,
  });

  factory OtherMeta.fromJson(Map<String, dynamic> json) =>
      _$OtherMetaFromJson(json);

  Map<String, dynamic> toJson() => _$OtherMetaToJson(this);
}
