import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_dimens.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../bloc/detail/detail_bloc.dart';
import '../bloc/detail/detail_event.dart';
import '../bloc/detail/detail_state.dart';

/// Pinned-to-bottom comment input on the detail page. Enforces a 50-char
/// limit (also enforced server-side by Firestore rules).
class AddCommentBar extends StatefulWidget {
  const AddCommentBar({super.key});

  @override
  State<AddCommentBar> createState() => _AddCommentBarState();
}

class _AddCommentBarState extends State<AddCommentBar> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text;
    if (text.trim().isEmpty) return;
    context.read<DetailBloc>().add(SubmitComment(text));
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DetailBloc, DetailState>(
      listenWhen: (prev, curr) =>
          prev.status == DetailStatus.submittingComment &&
          curr.status == DetailStatus.ready,
      listener: (context, _) {
        _focusNode.requestFocus();
      },
      buildWhen: (prev, curr) => prev.status != curr.status,
      builder: (context, state) {
        final submitting = state.status == DetailStatus.submittingComment;
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
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    enabled: !submitting,
                    minLines: 1,
                    maxLines: 3,
                    maxLength: 50,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _submit(),
                    decoration: InputDecoration(
                      hintText: context.l10n.discussionAddComment,
                      filled: true,
                      counterText: '',
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
                const SizedBox(width: AppDimens.spaceSm),
                IconButton.filled(
                  onPressed: submitting ? null : _submit,
                  icon: submitting
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
