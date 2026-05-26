import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/constants/app_dimens.dart';
import '../bloc/settings_bloc.dart';
import '../bloc/settings_event.dart';
import '../bloc/settings_state.dart';

class ThemeSelector extends StatelessWidget {
  const ThemeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(AppDimens.spaceLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.theme,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppDimens.spaceMd),
                SegmentedButton<String>(
                  segments: [
                    ButtonSegment(
                      value: 'light',
                      label: Text(context.l10n.lightMode),
                      icon: const Icon(Icons.light_mode),
                    ),
                    ButtonSegment(
                      value: 'system',
                      label: Text(context.l10n.systemMode,textAlign: TextAlign.center,),
                      icon: const Icon(Icons.settings_brightness),
                    ),
                    ButtonSegment(
                      value: 'dark',
                      label: Text(context.l10n.darkMode),
                      icon: const Icon(Icons.dark_mode),
                    ),
                  ],
                  selected: {state.themeMode},
                  onSelectionChanged: (selected) {
                    context
                        .read<SettingsBloc>()
                        .add(ChangeTheme(selected.first));
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}