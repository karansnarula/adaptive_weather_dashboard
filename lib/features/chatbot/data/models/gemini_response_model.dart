import 'package:json_annotation/json_annotation.dart';

import 'gemini_request_model.dart';

part 'gemini_response_model.g.dart';

/// Response body from Gemini `generateContent`. Only the fields we actually
/// read are modeled — `safetyRatings`, `promptFeedback`, token counts, etc.
/// are ignored.
@JsonSerializable(explicitToJson: true)
class GeminiResponseModel {
  final List<GeminiCandidate>? candidates;

  const GeminiResponseModel({this.candidates});

  factory GeminiResponseModel.fromJson(Map<String, dynamic> json) =>
      _$GeminiResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$GeminiResponseModelToJson(this);

  /// Convenience accessor — pulls the first text part from the first
  /// candidate. Returns an empty string if anything is missing so the
  /// repository can decide whether that constitutes a failure.
  String get firstText {
    final parts = candidates?.firstOrNull?.content?.parts;
    if (parts == null || parts.isEmpty) return '';
    return parts.map((p) => p.text).join('\n').trim();
  }
}

@JsonSerializable(explicitToJson: true)
class GeminiCandidate {
  final GeminiContent? content;
  @JsonKey(name: 'finishReason')
  final String? finishReason;

  const GeminiCandidate({this.content, this.finishReason});

  factory GeminiCandidate.fromJson(Map<String, dynamic> json) =>
      _$GeminiCandidateFromJson(json);

  Map<String, dynamic> toJson() => _$GeminiCandidateToJson(this);
}
