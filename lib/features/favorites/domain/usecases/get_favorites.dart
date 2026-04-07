import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../entities/favorite_city.dart';
import '../repositories/favorites_repository.dart';

@injectable
class GetFavorites {
  final FavoritesRepository _repository;

  const GetFavorites(this._repository);

  Future<Either<Failure, List<FavoriteCity>>> call() {
    return _repository.getFavorites();
  }
}