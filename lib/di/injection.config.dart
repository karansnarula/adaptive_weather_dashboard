// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:adaptive_weather_dashboard/di/app_module.dart' as _i59;
import 'package:adaptive_weather_dashboard/features/air_quality/data/air_quality_service.dart'
    as _i435;
import 'package:adaptive_weather_dashboard/features/auth/data/datasources/auth_remote_data_source.dart'
    as _i221;
import 'package:adaptive_weather_dashboard/features/auth/data/repositories/auth_repository_impl.dart'
    as _i1003;
import 'package:adaptive_weather_dashboard/features/auth/domain/repositories/auth_repository.dart'
    as _i480;
import 'package:adaptive_weather_dashboard/features/auth/domain/usecases/sign_in.dart'
    as _i101;
import 'package:adaptive_weather_dashboard/features/auth/domain/usecases/sign_out.dart'
    as _i610;
import 'package:adaptive_weather_dashboard/features/auth/domain/usecases/sign_up.dart'
    as _i151;
import 'package:adaptive_weather_dashboard/features/auth/presentation/bloc/auth_bloc.dart'
    as _i174;
import 'package:adaptive_weather_dashboard/features/chatbot/data/datasources/chat_quota_local_data_source.dart'
    as _i709;
import 'package:adaptive_weather_dashboard/features/chatbot/data/datasources/gemini_remote_data_source.dart'
    as _i46;
import 'package:adaptive_weather_dashboard/features/chatbot/data/repositories/chatbot_repository_impl.dart'
    as _i932;
import 'package:adaptive_weather_dashboard/features/chatbot/domain/repositories/chatbot_repository.dart'
    as _i482;
import 'package:adaptive_weather_dashboard/features/chatbot/domain/usecases/get_quota.dart'
    as _i110;
import 'package:adaptive_weather_dashboard/features/chatbot/domain/usecases/send_message.dart'
    as _i95;
import 'package:adaptive_weather_dashboard/features/chatbot/presentation/bloc/chatbot_bloc.dart'
    as _i1068;
import 'package:adaptive_weather_dashboard/features/favorites/data/datasources/favorites_local_data_source.dart'
    as _i388;
import 'package:adaptive_weather_dashboard/features/favorites/data/models/favorite_city_model.dart'
    as _i484;
import 'package:adaptive_weather_dashboard/features/favorites/data/repositories/favorites_repository_impl.dart'
    as _i74;
import 'package:adaptive_weather_dashboard/features/favorites/domain/repositories/favorites_repository.dart'
    as _i345;
import 'package:adaptive_weather_dashboard/features/favorites/domain/usecases/add_favorite.dart'
    as _i872;
import 'package:adaptive_weather_dashboard/features/favorites/domain/usecases/get_favorites.dart'
    as _i868;
import 'package:adaptive_weather_dashboard/features/favorites/domain/usecases/remove_favorite.dart'
    as _i666;
import 'package:adaptive_weather_dashboard/features/favorites/presentation/bloc/favorites_bloc.dart'
    as _i546;
import 'package:adaptive_weather_dashboard/features/notifications/data/datasources/notification_remote_data_source.dart'
    as _i311;
import 'package:adaptive_weather_dashboard/features/notifications/data/repositories/notification_repository_impl.dart'
    as _i979;
import 'package:adaptive_weather_dashboard/features/notifications/data/services/fcm_service.dart'
    as _i493;
import 'package:adaptive_weather_dashboard/features/notifications/domain/repositories/notification_repository.dart'
    as _i235;
import 'package:adaptive_weather_dashboard/features/notifications/domain/usecases/clear_notification_city.dart'
    as _i227;
import 'package:adaptive_weather_dashboard/features/notifications/domain/usecases/get_notification_city.dart'
    as _i281;
import 'package:adaptive_weather_dashboard/features/notifications/domain/usecases/set_notification_city.dart'
    as _i728;
import 'package:adaptive_weather_dashboard/features/notifications/presentation/bloc/notification_bloc.dart'
    as _i728;
import 'package:adaptive_weather_dashboard/features/settings/presentation/bloc/settings_bloc.dart'
    as _i408;
import 'package:adaptive_weather_dashboard/features/weather/data/datasources/weather_remote_data_source.dart'
    as _i650;
import 'package:adaptive_weather_dashboard/features/weather/data/repositories/weather_repository_impl.dart'
    as _i61;
import 'package:adaptive_weather_dashboard/features/weather/domain/repositories/weather_repository.dart'
    as _i315;
import 'package:adaptive_weather_dashboard/features/weather/domain/usecases/get_current_weather.dart'
    as _i728;
import 'package:adaptive_weather_dashboard/features/weather/domain/usecases/get_forecast.dart'
    as _i936;
import 'package:adaptive_weather_dashboard/features/weather/presentation/bloc/weather_bloc.dart'
    as _i806;
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:dio/dio.dart' as _i361;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:firebase_messaging/firebase_messaging.dart' as _i892;
import 'package:get_it/get_it.dart' as _i174;
import 'package:hive_ce/hive.dart' as _i738;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appModule = _$AppModule();
    await gh.singletonAsync<_i460.SharedPreferences>(
      () => appModule.prefs,
      preResolve: true,
    );
    await gh.singletonAsync<_i738.Box<_i484.FavoriteCityModel>>(
      () => appModule.favoritesBox,
      preResolve: true,
    );
    gh.lazySingleton<_i59.FirebaseAuth>(() => appModule.firebaseAuth);
    gh.lazySingleton<_i974.FirebaseFirestore>(() => appModule.firestore);
    gh.lazySingleton<_i892.FirebaseMessaging>(() => appModule.messaging);
    gh.lazySingleton<_i361.Dio>(
      () => appModule.chatbotDio,
      instanceName: 'chatbotDio',
    );
    gh.lazySingleton<_i361.Dio>(
      () => appModule.weatherDio,
      instanceName: 'weatherDio',
    );
    gh.lazySingleton<_i388.FavoritesLocalDataSource>(
      () => _i388.FavoritesLocalDataSource(
        gh<_i738.Box<_i484.FavoriteCityModel>>(),
      ),
    );
    gh.lazySingleton<_i435.AirQualityService>(
      () => _i435.AirQualityService(gh<_i361.Dio>(instanceName: 'weatherDio')),
    );
    gh.lazySingleton<_i46.GeminiRemoteDataSource>(
      () => _i46.GeminiRemoteDataSource(
        gh<_i361.Dio>(instanceName: 'chatbotDio'),
      ),
    );
    gh.lazySingleton<_i221.AuthRemoteDataSource>(
      () => _i221.AuthRemoteDataSource(
        gh<_i59.FirebaseAuth>(),
        gh<_i974.FirebaseFirestore>(),
      ),
    );
    gh.factory<_i408.SettingsBloc>(
      () => _i408.SettingsBloc(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i709.ChatQuotaLocalDataSource>(
      () => _i709.ChatQuotaLocalDataSource(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i480.AuthRepository>(
      () => _i1003.AuthRepositoryImpl(gh<_i221.AuthRemoteDataSource>()),
    );
    gh.factory<_i101.SignIn>(() => _i101.SignIn(gh<_i480.AuthRepository>()));
    gh.factory<_i610.SignOut>(() => _i610.SignOut(gh<_i480.AuthRepository>()));
    gh.factory<_i151.SignUp>(() => _i151.SignUp(gh<_i480.AuthRepository>()));
    gh.lazySingleton<_i311.NotificationRemoteDataSource>(
      () => _i311.NotificationRemoteDataSource(gh<_i974.FirebaseFirestore>()),
    );
    gh.lazySingleton<_i493.FcmService>(
      () => _i493.FcmService(
        gh<_i892.FirebaseMessaging>(),
        gh<_i974.FirebaseFirestore>(),
        gh<_i59.FirebaseAuth>(),
      ),
    );
    gh.lazySingleton<_i345.FavoritesRepository>(
      () => _i74.FavoritesRepositoryImpl(gh<_i388.FavoritesLocalDataSource>()),
    );
    gh.factory<_i872.AddFavorite>(
      () => _i872.AddFavorite(gh<_i345.FavoritesRepository>()),
    );
    gh.factory<_i868.GetFavorites>(
      () => _i868.GetFavorites(gh<_i345.FavoritesRepository>()),
    );
    gh.factory<_i666.RemoveFavorite>(
      () => _i666.RemoveFavorite(gh<_i345.FavoritesRepository>()),
    );
    gh.lazySingleton<_i482.ChatbotRepository>(
      () => _i932.ChatbotRepositoryImpl(
        gh<_i46.GeminiRemoteDataSource>(),
        gh<_i709.ChatQuotaLocalDataSource>(),
      ),
    );
    gh.factory<_i546.FavoritesBloc>(
      () => _i546.FavoritesBloc(
        gh<_i868.GetFavorites>(),
        gh<_i872.AddFavorite>(),
        gh<_i666.RemoveFavorite>(),
      ),
    );
    gh.lazySingleton<_i650.WeatherRemoteDataSource>(
      () => _i650.WeatherRemoteDataSource(
        gh<_i361.Dio>(instanceName: 'weatherDio'),
      ),
    );
    gh.factory<_i174.AuthBloc>(
      () => _i174.AuthBloc(
        gh<_i101.SignIn>(),
        gh<_i151.SignUp>(),
        gh<_i610.SignOut>(),
        gh<_i480.AuthRepository>(),
      ),
    );
    gh.lazySingleton<_i235.NotificationRepository>(
      () => _i979.NotificationRepositoryImpl(
        gh<_i311.NotificationRemoteDataSource>(),
      ),
    );
    gh.factory<_i110.GetQuota>(
      () => _i110.GetQuota(gh<_i482.ChatbotRepository>()),
    );
    gh.factory<_i95.SendMessage>(
      () => _i95.SendMessage(gh<_i482.ChatbotRepository>()),
    );
    gh.lazySingleton<_i315.WeatherRepository>(
      () => _i61.WeatherRepositoryImpl(gh<_i650.WeatherRemoteDataSource>()),
    );
    gh.factory<_i1068.ChatbotBloc>(
      () => _i1068.ChatbotBloc(gh<_i95.SendMessage>(), gh<_i110.GetQuota>()),
    );
    gh.factory<_i728.GetCurrentWeather>(
      () => _i728.GetCurrentWeather(gh<_i315.WeatherRepository>()),
    );
    gh.factory<_i936.GetForecast>(
      () => _i936.GetForecast(gh<_i315.WeatherRepository>()),
    );
    gh.factory<_i227.ClearNotificationCity>(
      () => _i227.ClearNotificationCity(gh<_i235.NotificationRepository>()),
    );
    gh.factory<_i281.GetNotificationCity>(
      () => _i281.GetNotificationCity(gh<_i235.NotificationRepository>()),
    );
    gh.factory<_i728.SetNotificationCity>(
      () => _i728.SetNotificationCity(gh<_i235.NotificationRepository>()),
    );
    gh.factory<_i728.NotificationBloc>(
      () => _i728.NotificationBloc(
        gh<_i281.GetNotificationCity>(),
        gh<_i728.SetNotificationCity>(),
        gh<_i227.ClearNotificationCity>(),
      ),
    );
    gh.factory<_i806.WeatherBloc>(
      () => _i806.WeatherBloc(
        gh<_i728.GetCurrentWeather>(),
        gh<_i936.GetForecast>(),
      ),
    );
    return this;
  }
}

class _$AppModule extends _i59.AppModule {}
