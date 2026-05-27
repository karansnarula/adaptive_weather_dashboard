import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_dimens.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../bloc/chatbot_bloc.dart';
import '../bloc/chatbot_event.dart';
import '../bloc/chatbot_state.dart';

class ChatInputBar extends StatefulWidget {
  const ChatInputBar({super.key});

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submit(ChatbotState state) {
    final text = _controller.text;
    if (text.trim().isEmpty) return;
    if (state.status == ChatbotStatus.sending) return;
    if (state.status == ChatbotStatus.quotaExceeded) return;
    context.read<ChatbotBloc>().add(SendUserMessage(text));
    _controller.clear();
    // Keep focus so users can keep typing on desktop without re-clicking.
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatbotBloc, ChatbotState>(
      buildWhen: (prev, curr) => prev.status != curr.status,
      builder: (context, state) {
        final disabled = state.status == ChatbotStatus.sending ||
            state.status == ChatbotStatus.quotaExceeded;
        return Container(
          padding: const EdgeInsets.fromLTRB(
            AppDimens.spaceLg,
            AppDimens.spaceSm,
            AppDimens.spaceLg,
            AppDimens.spaceLg,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border(
              top: BorderSide(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.4),
                width: AppDimens.borderThin,
              ),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Shortcuts(
                    shortcuts: const <ShortcutActivator, Intent>{
                      SingleActivator(LogicalKeyboardKey.enter):
                          _SubmitIntent(),
                    },
                    child: Actions(
                      actions: <Type, Action<Intent>>{
                        _SubmitIntent: CallbackAction<_SubmitIntent>(
                          onInvoke: (_) {
                            _submit(state);
                            return null;
                          },
                        ),
                      },
                      child: TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        enabled: !disabled,
                        minLines: 1,
                        maxLines: 4,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _submit(state),
                        decoration: InputDecoration(
                          hintText: state.status == ChatbotStatus.quotaExceeded
                              ? context.l10n.chatbotQuotaExceeded
                              : context.l10n.chatbotInputHint,
                          filled: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: AppDimens.spaceLg,
                            vertical: AppDimens.spaceMd,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              AppDimens.radiusXl,
                            ),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppDimens.spaceSm),
                IconButton.filled(
                  onPressed: disabled ? null : () => _submit(state),
                  icon: state.status == ChatbotStatus.sending
                      ? const SizedBox(
                          width: AppDimens.iconSm,
                          height: AppDimens.iconSm,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.send),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SubmitIntent extends Intent {
  const _SubmitIntent();
}
