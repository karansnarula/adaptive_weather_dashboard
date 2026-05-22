import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/config/app_config.dart';
import '../features/favorites/data/models/favorite_city_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

@module
abstract class AppModule {
  @preResolve
  @singleton
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  @preResolve
  @singleton
  Future<Box<FavoriteCityModel>> get favoritesBox async {
    Hive.registerAdapter(FavoriteCityModelAdapter());
    return Hive.openBox<FavoriteCityModel>('favorites');
  }

  @lazySingleton
  FirebaseAuth get firebaseAuth => FirebaseAuth.instance;

  @lazySingleton
  FirebaseFirestore get firestore => FirebaseFirestore.instance;

  @lazySingleton
  FirebaseMessaging get messaging => FirebaseMessaging.instance;

  @lazySingleton
  Dio get dio => Dio(
    BaseOptions(
      baseUrl: AppConfig.instance.apiBaseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      queryParameters: {
        'appid': AppConfig.instance.apiKey,
      },
    ),
  )..interceptors.add(
    PrettyDioLogger(
      requestBody: true,
      responseBody: true,
    ),
  );
}