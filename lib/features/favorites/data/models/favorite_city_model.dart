import 'package:hive_ce/hive.dart';

import '../../domain/entities/favorite_city.dart';

part 'favorite_city_model.g.dart';

@HiveType(typeId: 0)
class FavoriteCityModel extends HiveObject {
  @HiveField(0)
  final String name;

  FavoriteCityModel({required this.name});

  FavoriteCity toEntity() => FavoriteCity(name: name);

  factory FavoriteCityModel.fromEntity(FavoriteCity entity) =>
      FavoriteCityModel(name: entity.name);
}