import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../notifications/presentation/widgets/notification_city_card.dart';
import '../bloc/settings_bloc.dart';
import '../bloc/settings_state.dart';
import '../widgets/language_selector.dart';
import '../widgets/unit_selector.dart';
import '../widgets/theme_selector.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.navSettings),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppDimens.contentMaxWidthSm),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimens.spaceLg),
            child: Column(
              children: [
                const NotificationCityCard(),
                const SizedBox(height: AppDimens.spaceLg),
                const LanguageSelector(),
                const SizedBox(height: AppDimens.spaceLg),
                const UnitSelector(),
                const SizedBox(height: AppDimens.spaceLg),
                const ThemeSelector(),
                const SizedBox(height: AppDimens.space3xl),
                BlocBuilder<SettingsBloc, SettingsState>(
                  buildWhen: (previous, current) =>
                  previous.appVersion != current.appVersion,
                  builder: (context, state) {
                    return Text(
                      context.l10n.appVersion(state.appVersion),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    );
                  },
                ),
                const SizedBox(height: AppDimens.space3xl),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      context.read<AuthBloc>().add(const AuthSignOutRequested());
                    },
                    icon: const Icon(Icons.logout),
                    label: Text(context.l10n.logout),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.error,
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.error,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: AppDimens.spaceLg),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimens.radiusMd),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}