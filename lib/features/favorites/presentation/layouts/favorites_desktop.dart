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
        child: GridView.builder(
          padding: const EdgeInsets.all(32),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
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
        ),
      ),
    );
  }
}