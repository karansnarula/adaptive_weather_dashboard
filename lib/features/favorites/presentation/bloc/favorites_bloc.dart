import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/usecases/get_favorites.dart';
import '../../domain/usecases/add_favorite.dart';
import '../../domain/usecases/remove_favorite.dart';
import 'favorites_event.dart';
import 'favorites_state.dart';

@injectable
class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final GetFavorites _getFavorites;
  final AddFavorite _addFavorite;
  final RemoveFavorite _removeFavorite;

  FavoritesBloc(
      this._getFavorites,
      this._addFavorite,
      this._removeFavorite,
      ) : super(const FavoritesInitial()) {
    on<LoadFavorites>(_onLoadFavorites);
    on<AddFavoriteCity>(_onAddFavorite);
    on<RemoveFavoriteCity>(_onRemoveFavorite);
  }

  Future<void> _onLoadFavorites(
      LoadFavorites event,
      Emitter<FavoritesState> emit,
      ) async {
    emit(const FavoritesLoading());

    final result = await _getFavorites();
    result.fold(
          (failure) => emit(FavoritesError(failure.message)),
          (favorites) => emit(FavoritesLoaded(favorites)),
    );
  }

  Future<void> _onAddFavorite(
      AddFavoriteCity event,
      Emitter<FavoritesState> emit,
      ) async {
    final result = await _addFavorite(event.cityName);
    result.fold(
          (failure) => emit(FavoritesError(failure.message)),
          (_) => add(const LoadFavorites()),
    );
  }

  Future<void> _onRemoveFavorite(
      RemoveFavoriteCity event,
      Emitter<FavoritesState> emit,
      ) async {
    final result = await _removeFavorite(event.cityName);
    result.fold(
          (failure) => emit(FavoritesError(failure.message)),
          (_) => add(const LoadFavorites()),
    );
  }
}