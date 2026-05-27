// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gemini_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GeminiResponseModel _$GeminiResponseModelFromJson(Map<String, dynamic> json) =>
    GeminiResponseModel(
      candidates: (json['candidates'] as List<dynamic>?)
          ?.map((e) => GeminiCandidate.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GeminiResponseModelToJson(
  GeminiResponseModel instance,
) => <String, dynamic>{
  'candidates': instance.candidates?.map((e) => e.toJson()).toList(),
};

GeminiCandidate _$GeminiCandidateFromJson(Map<String, dynamic> json) =>
    GeminiCandidate(
      content: json['content'] == null
          ? null
          : GeminiContent.fromJson(json['content'] as Map<String, dynamic>),
      finishReason: json['finishReason'] as String?,
    );

Map<String, dynamic> _$GeminiCandidateToJson(GeminiCandidate instance) =>
    <String, dynamic>{
      'content': instance.content?.toJson(),
      'finishReason': instance.finishReason,
    };
