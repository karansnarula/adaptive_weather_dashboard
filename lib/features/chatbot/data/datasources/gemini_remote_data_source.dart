import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../models/gemini_request_model.dart';
import '../models/gemini_response_model.dart';

part 'gemini_remote_data_source.g.dart';

/// Model identifier used in the Gemini endpoint path. Centralised so a
/// future upgrade (e.g. `gemini-2.5-pro`) is a one-line change.
const String kGeminiModel = 'gemini-2.5-flash';

@RestApi()
@lazySingleton
abstract class GeminiRemoteDataSource {
  @factoryMethod
  factory GeminiRemoteDataSource(@Named('chatbotDio') Dio dio) =
      _GeminiRemoteDataSource;

  @POST('/models/$kGeminiModel:generateContent')
  Future<GeminiResponseModel> generateContent(
    @Body() GeminiRequestModel request,
  );
}
