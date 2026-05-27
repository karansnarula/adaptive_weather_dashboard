import 'package:json_annotation/json_annotation.dart';

part 'gemini_request_model.g.dart';

/// Request body for the Gemini `generateContent` endpoint.
///
/// Shape (per https://ai.google.dev/api/generate-content):
/// ```json
/// {
///   "systemInstruction": { "parts": [{ "text": "..." }] },
///   "contents": [
///     { "role": "user", "parts": [{ "text": "..." }] }
///   ]
/// }
/// ```
@JsonSerializable(
  explicitToJson: true,
  includeIfNull: false,
  createFactory: false,
)
class GeminiRequestModel {
  @JsonKey(name: 'systemInstruction')
  final GeminiContent? systemInstruction;
  final List<GeminiContent> contents;

  const GeminiRequestModel({
    this.systemInstruction,
    required this.contents,
  });

  Map<String, dynamic> toJson() => _$GeminiRequestModelToJson(this);
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class GeminiContent {
  /// 'user' or 'model'. Omitted in `systemInstruction`.
  final String? role;
  final List<GeminiPart> parts;

  const GeminiContent({this.role, required this.parts});

  factory GeminiContent.fromJson(Map<String, dynamic> json) =>
      _$GeminiContentFromJson(json);

  Map<String, dynamic> toJson() => _$GeminiContentToJson(this);
}

@JsonSerializable()
class GeminiPart {
  final String text;

  const GeminiPart({required this.text});

  factory GeminiPart.fromJson(Map<String, dynamic> json) =>
      _$GeminiPartFromJson(json);

  Map<String, dynamic> toJson() => _$GeminiPartToJson(this);
}
