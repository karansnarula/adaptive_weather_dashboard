import 'package:flutter/material.dart';

import '../../domain/entities/favorite_city.dart';
import '../widgets/favorite_city_tile.dart';

class FavoritesTablet extends StatelessWidget {
  final List<FavoriteCity> favorites;
  final ValueChanged<String> onCityTap;
  final ValueChanged<String> onRemove;

  const FavoritesTablet({
    super.key,
    required this.favorites,
    required this.onCityTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 3,
      ),
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        final city = favorites[index];
        return FavoriteCityTile(
          city: city,
          onTap: () => onCityTap(city.name),
          onRemove: () => onRemove(city.name),
        );
      },
    );
  }
}