import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/favorite_city.dart';

abstract class FavoritesRepository {
  Future<Either<Failure, List<FavoriteCity>>> getFavorites();
  Future<Either<Failure, void>> addFavorite(String cityName);
  Future<Either<Failure, void>> removeFavorite(String cityName);
}