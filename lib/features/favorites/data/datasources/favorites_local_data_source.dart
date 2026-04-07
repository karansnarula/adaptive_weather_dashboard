import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';

import '../models/favorite_city_model.dart';

@lazySingleton
class FavoritesLocalDataSource {
  final Box<FavoriteCityModel> _box;

  const FavoritesLocalDataSource(this._box);

  List<FavoriteCityModel> getFavorites() {
    return _box.values.toList();
  }

  Future<void> addFavorite(String cityName) async {
    final exists = _box.values.any((city) => city.name == cityName);
    if (!exists) {
      await _box.add(FavoriteCityModel(name: cityName));
    }
  }

  Future<void> removeFavorite(String cityName) async {
    final key = _box.keys.firstWhere(
          (k) => _box.get(k)?.name == cityName,
      orElse: () => null,
    );
    if (key != null) {
      await _box.delete(key);
    }
  }
}