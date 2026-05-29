import 'package:adaptive_weather_dashboard/core/l10n/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_dimens.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../bloc/notification_bloc.dart';
import '../bloc/notification_event.dart';
import '../bloc/notification_state.dart';

class NotificationCityCard extends StatelessWidget {
  const NotificationCityCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationBloc, NotificationState>(
      builder: (context, state) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(AppDimens.spaceLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.dailyWeatherNotification,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppDimens.spaceMd),
                if (state is NotificationLoaded && state.hasCity)
                  ListTile(
                    leading: Icon(
                      Icons.notifications_active,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: Text(state.city!.cityName),
                    subtitle: Text(
                      context.l10n.dailyWeatherUpdates,
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      onPressed: () {
                        final authState = context.read<AuthBloc>().state;
                        if (authState is Authenticated) {
                          context.read<NotificationBloc>().add(
                            ClearNotificationCityEvent(authState.user.uid),
                          );
                        }
                      },
                    ),
                  )
                else
                  ListTile(
                    leading: Icon(
                      Icons.notifications_none,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    title: Text(context.l10n.noNotificationCity),
                    subtitle: Text(
                      context.l10n.notificationHint,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}