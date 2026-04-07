import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../repositories/favorites_repository.dart';

@injectable
class AddFavorite {
  final FavoritesRepository _repository;

  const AddFavorite(this._repository);

  Future<Either<Failure, void>> call(String cityName) {
    return _repository.addFavorite(cityName);
  }
}