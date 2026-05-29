import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_dimens.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../domain/entities/comment.dart';
import '../../domain/entities/post.dart';
import '../bloc/detail/detail_bloc.dart';
import '../bloc/detail/detail_event.dart';
import '../bloc/detail/detail_state.dart';
import '../widgets/add_comment_bar.dart';
import '../widgets/comment_tile.dart';
import '../widgets/like_button.dart';
import '../widgets/post_image.dart';

class DetailMobile extends StatelessWidget {
  const DetailMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailBloc, DetailState>(
      builder: (context, state) {
        if (state.status == DetailStatus.initial ||
            state.status == DetailStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.status == DetailStatus.error || state.post == null) {
          return Center(
            child: Text(state.errorMessage ?? context.l10n.errorGeneric),
          );
        }
        final post = state.post!;
        return Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  context.read<DetailBloc>().add(const RefreshDetail());
                },
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppDimens.spaceLg,
                  ),
                  children: [
                    _PostHeader(
                      post: post,
                      currentUserId: state.currentUserId,
                    ),
                    const SizedBox(height: AppDimens.spaceLg),
                    if (state.comments.isEmpty)
                      _emptyComments(context)
                    else
                      ..._buildCommentList(
                        context,
                        state.comments,
                        post,
                        state.currentUserId,
                      ),
                  ],
                ),
              ),
            ),
            const AddCommentBar(),
          ],
        );
      },
    );
  }

  Widget _emptyComments(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: AppDimens.spaceLg,
      vertical: AppDimens.space2xl,
    ),
    child: Text(
      context.l10n.discussionNoCommentsYet,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
    ),
  );

  List<Widget> _buildCommentList(
    BuildContext context,
    List<Comment> comments,
    Post post,
    String? currentUserId,
  ) => [
    for (final c in comments)
      CommentTile(
        comment: c,
        canDelete: currentUserId != null &&
            (c.authorId == currentUserId || post.authorId == currentUserId),
        onDelete: () => _confirmDeleteComment(context, c),
      ),
  ];

  Future<void> _confirmDeleteComment(
    BuildContext context,
    Comment comment,
  ) async {
    final l = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.discussionDeleteCommentTitle),
        content: Text(l.discussionDeleteCommentBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l.discussionCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l.discussionDelete),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      context.read<DetailBloc>().add(DeleteOneComment(comment.id));
    }
  }
}

class _PostHeader extends StatelessWidget {
  final Post post;
  final String? currentUserId;

  const _PostHeader({required this.post, required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final dateText = DateFormat('dd/MM/yyyy').format(post.createdAt.toLocal());
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            post.title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: AppDimens.spaceXs),
          Text(
            '${context.l10n.discussionByAuthor(post.authorName)} • $dateText',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
          ),
          if (post.imageUrl.trim().isNotEmpty) ...[
            const SizedBox(height: AppDimens.spaceLg),
            PostImage(url: post.imageUrl, aspectRatio: 16 / 10),
          ],
          if (post.description.trim().isNotEmpty) ...[
            const SizedBox(height: AppDimens.spaceLg),
            Text(post.description, style: Theme.of(context).textTheme.bodyLarge),
          ],
          const SizedBox(height: AppDimens.spaceLg),
          Row(
            children: [
              LikeButton(
                isLiked: post.isLikedBy(currentUserId),
                count: post.likeCount,
                onTap: () =>
                    context.read<DetailBloc>().add(const ToggleLikeOnDetail()),
              ),
              const SizedBox(width: AppDimens.spaceMd),
              Icon(
                Icons.chat_bubble_outline,
                size: AppDimens.iconSm,
                color: scheme.onSurfaceVariant,
              ),
              const SizedBox(width: AppDimens.spaceXs),
              Text(
                '${post.commentCount}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
