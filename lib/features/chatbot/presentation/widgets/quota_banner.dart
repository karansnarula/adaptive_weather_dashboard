import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_dimens.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../domain/entities/chat_quota.dart';
import '../bloc/chatbot_bloc.dart';
import '../bloc/chatbot_state.dart';

/// Sits between the message list and the input bar. Renders the full
/// quota-exceeded detail message only when [ChatbotStatus.quotaExceeded] —
/// otherwise it occupies zero height.
class QuotaBanner extends StatelessWidget {
  const QuotaBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatbotBloc, ChatbotState>(
      buildWhen: (prev, curr) => prev.status != curr.status,
      builder: (context, state) {
        if (state.status != ChatbotStatus.quotaExceeded) {
          return const SizedBox.shrink();
        }
        final scheme = Theme.of(context).colorScheme;
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(
            horizontal: AppDimens.spaceLg,
            vertical: AppDimens.spaceSm,
          ),
          padding: const EdgeInsets.all(AppDimens.spaceLg),
          decoration: BoxDecoration(
            color: scheme.errorContainer,
            borderRadius: BorderRadius.circular(AppDimens.radiusLg),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.lock_clock_outlined,
                color: scheme.onErrorContainer,
                size: AppDimens.iconMd,
              ),
              const SizedBox(width: AppDimens.spaceMd),
              Expanded(
                child: Text(
                  context.l10n.chatbotQuotaExceededDetail(
                    kChatbotDailyMessageLimit,
                  ),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: scheme.onErrorContainer,
                      ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
