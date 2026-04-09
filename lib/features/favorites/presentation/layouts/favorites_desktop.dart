import 'package:flutter/material.dart';

import '../../domain/entities/favorite_city.dart';
import '../widgets/favorite_city_tile.dart';

class FavoritesDesktop extends StatelessWidget {
  final List<FavoriteCity> favorites;
  final ValueChanged<String> onCityTap;
  final ValueChanged<String> onRemove;

  const FavoritesDesktop({
    super.key,
    required this.favorites,
    required this.onCityTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1000),
        child: ListView.builder(
          padding: const EdgeInsets.all(32),
          itemCount: favorites.length,
          itemBuilder: (context, index) {
            final city = favorites[index];
            return ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: FavoriteCityTile(
                city: city,
                onTap: () => onCityTap(city.name),
                onRemove: () => onRemove(city.name),
              ),
            );
          },
        ),
      ),
    );
  }
}