import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimens.dart';
import '../../domain/entities/favorite_city.dart';
import '../widgets/favorite_city_tile.dart';

class FavoritesMobile extends StatelessWidget {
  final List<FavoriteCity> favorites;
  final ValueChanged<String> onCityTap;
  final ValueChanged<String> onRemove;

  const FavoritesMobile({
    super.key,
    required this.favorites,
    required this.onCityTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppDimens.spaceLg),
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