import 'package:adaptive_weather_dashboard/core/l10n/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_dimens.dart';
import '../bloc/settings_bloc.dart';
import '../bloc/settings_event.dart';
import '../bloc/settings_state.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(AppDimens.spaceLg),
            child: RadioGroup(
              groupValue: state.languageCode,
              onChanged: (value) {
                if (value != null) {
                  context.read<SettingsBloc>().add(ChangeLanguage(value));
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.language,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppDimens.spaceMd),
                  RadioListTile<String>(
                    title: const Text('English'),
                    value: 'en',
                  ),
                  RadioListTile<String>(
                      title: const Text('ไทย'),
                      value: 'th',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
