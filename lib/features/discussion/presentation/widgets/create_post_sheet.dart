import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_dimens.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../di/injection.dart';
import '../bloc/create_post/create_post_bloc.dart';
import '../bloc/create_post/create_post_event.dart';
import '../bloc/create_post/create_post_state.dart';
import 'event_chip_row.dart';

/// Modal bottom sheet for composing a new post. Returns the freshly
/// created post (or null on cancel) so the caller can prepend it to
/// the feed without a refresh round-trip.
Future<void> showCreatePostSheet(
  BuildContext context, {
  required String city,
  required void Function(CreatePostState state) onSubmitted,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (sheetContext) {
      return BlocProvider<CreatePostBloc>(
        create: (_) => getIt<CreatePostBloc>(param1: city),
        child: _CreatePostForm(onSubmitted: onSubmitted),
      );
    },
  );
}

class _CreatePostForm extends StatefulWidget {
  final void Function(CreatePostState state) onSubmitted;

  const _CreatePostForm({required this.onSubmitted});

  @override
  State<_CreatePostForm> createState() => _CreatePostFormState();
}

class _CreatePostFormState extends State<_CreatePostForm> {
  late final TextEditingController _titleController;
  late final TextEditingController _imageUrlController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _imageUrlController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _imageUrlController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreatePostBloc, CreatePostState>(
      listenWhen: (prev, curr) => prev.status != curr.status ||
          prev.title != curr.title,
      listener: (context, state) {
        // Sync the title controller when the chip taps mutate state.
        if (_titleController.text != state.title) {
          _titleController.value = TextEditingValue(
            text: state.title,
            selection: TextSelection.collapsed(offset: state.title.length),
          );
        }
        if (state.status == CreatePostStatus.success) {
          widget.onSubmitted(state);
          Navigator.of(context).pop();
        } else if (state.status == CreatePostStatus.failure &&
            state.errorMessage != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        }
      },
      builder: (context, state) {
        final l10n = context.l10n;
        final bloc = context.read<CreatePostBloc>();
        return Padding(
          padding: EdgeInsets.only(
            left: AppDimens.spaceLg,
            right: AppDimens.spaceLg,
            top: AppDimens.spaceSm,
            bottom: MediaQuery.viewInsetsOf(context).bottom + AppDimens.spaceLg,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.discussionCreatePostTitle,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: AppDimens.spaceMd),
                Text(
                  l10n.discussionCreatePostUnder(state.city),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: AppDimens.spaceLg),
                TextField(
                  controller: _titleController,
                  maxLength: 100,
                  onChanged: (v) => bloc.add(TitleChanged(v)),
                  decoration: InputDecoration(
                    labelText: l10n.discussionTitleLabel,
                    counterText: '',
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: AppDimens.spaceMd),
                EventChipRow(
                  selected: state.eventType,
                  onTap: (t) => bloc.add(EventChipTapped(t)),
                ),
                const SizedBox(height: AppDimens.spaceLg),
                TextField(
                  controller: _imageUrlController,
                  onChanged: (v) => bloc.add(ImageUrlChanged(v)),
                  decoration: InputDecoration(
                    labelText: l10n.discussionImageUrlLabel,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: AppDimens.spaceLg),
                TextField(
                  controller: _descriptionController,
                  onChanged: (v) => bloc.add(DescriptionChanged(v)),
                  minLines: 3,
                  maxLines: 6,
                  maxLength: 200,
                  decoration: InputDecoration(
                    labelText: l10n.discussionDescriptionLabel,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: AppDimens.spaceLg),
                FilledButton(
                  onPressed: state.canSubmit
                      ? () => bloc.add(const SubmitNewPost())
                      : null,
                  child: state.status == CreatePostStatus.submitting
                      ? const SizedBox(
                          width: AppDimens.iconSm,
                          height: AppDimens.iconSm,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(l10n.discussionSubmitPost),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
