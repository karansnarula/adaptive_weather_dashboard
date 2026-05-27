import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_dimens.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../domain/entities/chat_quota.dart';
import '../bloc/chatbot_bloc.dart';
import '../bloc/chatbot_state.dart';

/// Compact quota chip rendered in the chatbot AppBar's actions slot.
/// Shows `used / limit` and a tooltip with the reset time.
class QuotaIndicator extends StatelessWidget {
  const QuotaIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatbotBloc, ChatbotState>(
      buildWhen: (prev, curr) => prev.quota != curr.quota,
      builder: (context, state) {
        final quota = state.quota;
        if (quota == null) return const SizedBox.shrink();
        final scheme = Theme.of(context).colorScheme;
        final time = DateFormat.Hm().format(quota.resetAt.toLocal());

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceSm),
          child: Tooltip(
            message: context.l10n.chatbotQuotaResetAt(time),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.spaceMd,
                  vertical: AppDimens.spaceXxs,
                ),
                decoration: BoxDecoration(
                  color: quota.isExhausted
                      ? scheme.errorContainer
                      : scheme.primaryContainer,
                  borderRadius: BorderRadius.circular(AppDimens.radiusLg),
                ),
                child: Text(
                  '${quota.used} / $kChatbotDailyMessageLimit',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: quota.isExhausted
                            ? scheme.onErrorContainer
                            : scheme.onPrimaryContainer,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
