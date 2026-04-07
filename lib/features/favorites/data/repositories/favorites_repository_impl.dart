import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/favorite_city.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../datasources/favorites_local_data_source.dart';

@LazySingleton(as: FavoritesRepository)
class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesLocalDataSource _localDataSource;

  const FavoritesRepositoryImpl(this._localDataSource);

  @override
  Future<Either<Failure, List<FavoriteCity>>> getFavorites() async {
    try {
      final result = _localDataSource.getFavorites();
      return right(result.map((model) => model.toEntity()).toList());
    } catch (e) {
      return left(const CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> addFavorite(String cityName) async {
    try {
      await _localDataSource.addFavorite(cityName);
      return right(null);
    } catch (e) {
      return left(const CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> removeFavorite(String cityName) async {
    try {
      await _localDataSource.removeFavorite(cityName);
      return right(null);
    } catch (e) {
      return left(const CacheFailure());
    }
  }
}