import 'package:adaptive_weather_dashboard/core/l10n/l10n_extension.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/favorite_city.dart';

class FavoriteCityTile extends StatelessWidget {
  final FavoriteCity city;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const FavoriteCityTile({
    super.key,
    required this.city,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const CircleAvatar(
          child: Icon(Icons.location_city),
        ),
        title: Text(
          city.name,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(context.l10n.tapToViewWeather),
        trailing: IconButton(
          icon: Icon(
            Icons.delete_outline,
            color: Theme.of(context).colorScheme.error,
          ),
          onPressed: onRemove,
        ),
        onTap: onTap,
      ),
    );
  }
}