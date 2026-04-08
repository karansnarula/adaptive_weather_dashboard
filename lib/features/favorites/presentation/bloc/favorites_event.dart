sealed class FavoritesEvent {
  const FavoritesEvent();
}

class LoadFavorites extends FavoritesEvent {
  const LoadFavorites();
}

class AddFavoriteCity extends FavoritesEvent {
  final String cityName;

  const AddFavoriteCity(this.cityName);
}

class RemoveFavoriteCity extends FavoritesEvent {
  final String cityName;

  const RemoveFavoriteCity(this.cityName);
}