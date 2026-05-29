// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gemini_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$GeminiRequestModelToJson(GeminiRequestModel instance) =>
    <String, dynamic>{
      'systemInstruction': ?instance.systemInstruction?.toJson(),
      'contents': instance.contents.map((e) => e.toJson()).toList(),
    };

GeminiContent _$GeminiContentFromJson(Map<String, dynamic> json) =>
    GeminiContent(
      role: json['role'] as String?,
      parts: (json['parts'] as List<dynamic>)
          .map((e) => GeminiPart.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GeminiContentToJson(GeminiContent instance) =>
    <String, dynamic>{
      'role': ?instance.role,
      'parts': instance.parts.map((e) => e.toJson()).toList(),
    };

GeminiPart _$GeminiPartFromJson(Map<String, dynamic> json) =>
    GeminiPart(text: json['text'] as String);

Map<String, dynamic> _$GeminiPartToJson(GeminiPart instance) =>
    <String, dynamic>{'text': instance.text};
