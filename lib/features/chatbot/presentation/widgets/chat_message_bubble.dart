import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimens.dart';
import '../../domain/entities/chat_message.dart';

class ChatMessageBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatMessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isUser = message.isUser;

    final bg = isUser ? scheme.primary : scheme.surfaceContainerHigh;
    final fg = isUser ? scheme.onPrimary : scheme.onSurface;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.78,
        ),
        margin: const EdgeInsets.symmetric(vertical: AppDimens.spaceXs),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.spaceLg,
          vertical: AppDimens.spaceMd,
        ),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(AppDimens.radiusLg),
            topRight: const Radius.circular(AppDimens.radiusLg),
            bottomLeft: Radius.circular(
              isUser ? AppDimens.radiusLg : AppDimens.radiusXs,
            ),
            bottomRight: Radius.circular(
              isUser ? AppDimens.radiusXs : AppDimens.radiusLg,
            ),
          ),
        ),
        child: Text(
          message.text,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: fg),
        ),
      ),
    );
  }
}
