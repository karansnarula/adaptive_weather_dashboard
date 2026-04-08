// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:adaptive_weather_dashboard/di/app_module.dart' as _i59;
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
import 'package:dio/dio.dart' as _i361;
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
    gh.lazySingleton<_i361.Dio>(() => appModule.dio);
    gh.lazySingleton<_i388.FavoritesLocalDataSource>(
      () => _i388.FavoritesLocalDataSource(
        gh<_i738.Box<_i484.FavoriteCityModel>>(),
      ),
    );
    gh.lazySingleton<_i650.WeatherRemoteDataSource>(
      () => _i650.WeatherRemoteDataSource(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i345.FavoritesRepository>(
      () => _i74.FavoritesRepositoryImpl(gh<_i388.FavoritesLocalDataSource>()),
    );
    gh.lazySingleton<_i315.WeatherRepository>(
      () => _i61.WeatherRepositoryImpl(gh<_i650.WeatherRemoteDataSource>()),
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
    gh.factory<_i546.FavoritesBloc>(
      () => _i546.FavoritesBloc(
        gh<_i868.GetFavorites>(),
        gh<_i872.AddFavorite>(),
        gh<_i666.RemoveFavorite>(),
      ),
    );
    gh.factory<_i728.GetCurrentWeather>(
      () => _i728.GetCurrentWeather(gh<_i315.WeatherRepository>()),
    );
    gh.factory<_i936.GetForecast>(
      () => _i936.GetForecast(gh<_i315.WeatherRepository>()),
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
