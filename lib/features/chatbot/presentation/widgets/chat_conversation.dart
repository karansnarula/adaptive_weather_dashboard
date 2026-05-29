import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_dimens.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../bloc/chatbot_bloc.dart';
import '../bloc/chatbot_state.dart';
import 'chat_message_bubble.dart';
import 'typing_indicator.dart';

/// The scrolling message list shared by every responsive layout.
///
/// When the message list is empty the widget renders an empty-state greeting
/// whose copy adapts to whether a city was provided via the route param.
class ChatConversation extends StatefulWidget {
  const ChatConversation({super.key});

  @override
  State<ChatConversation> createState() => _ChatConversationState();
}

class _ChatConversationState extends State<ChatConversation> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatbotBloc, ChatbotState>(
      listenWhen: (prev, curr) =>
          prev.messages.length != curr.messages.length ||
          prev.status != curr.status,
      listener: (context, state) => _scrollToBottom(),
      builder: (context, state) {
        if (state.messages.isEmpty && state.status != ChatbotStatus.sending) {
          return _EmptyState(city: state.city);
        }

        final itemCount = state.messages.length +
            (state.status == ChatbotStatus.sending ? 1 : 0);

        return ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.spaceLg,
            vertical: AppDimens.spaceLg,
          ),
          itemCount: itemCount,
          itemBuilder: (context, index) {
            if (index >= state.messages.length) {
              return const TypingIndicator();
            }
            return ChatMessageBubble(message: state.messages[index]);
          },
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String? city;

  const _EmptyState({this.city});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final greeting = city == null || city!.trim().isEmpty
        ? context.l10n.chatbotEmptyStateGeneric
        : context.l10n.chatbotEmptyStateWithCity(city!);
    return Padding(
      padding: const EdgeInsets.all(AppDimens.space2xl),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.smart_toy_outlined,
              size: AppDimens.iconLogo,
              color: scheme.primary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppDimens.spaceLg),
            Text(
              greeting,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
