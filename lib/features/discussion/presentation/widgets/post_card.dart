import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_dimens.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../domain/entities/post.dart';
import 'like_button.dart';
import 'post_image.dart';

/// One entry in the feed list. Tap → detail page. Heart → optimistic
/// like toggle on the feed bloc.
class PostCard extends StatelessWidget {
  final Post post;
  final String? currentUserId;
  final VoidCallback onTap;
  final VoidCallback onLike;

  const PostCard({
    super.key,
    required this.post,
    required this.currentUserId,
    required this.onTap,
    required this.onLike,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final dateText = DateFormat('dd/MM/yyyy').format(post.createdAt.toLocal());

    return Card(
      margin: const EdgeInsets.symmetric(vertical: AppDimens.spaceSm),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.spaceLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              if (post.imageUrl.trim().isNotEmpty) ...[
                const SizedBox(height: AppDimens.spaceMd),
                PostImage(url: post.imageUrl),
              ],
              if (post.description.trim().isNotEmpty) ...[
                const SizedBox(height: AppDimens.spaceMd),
                Text(
                  post.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
              const SizedBox(height: AppDimens.spaceMd),
              Row(
                children: [
                  LikeButton(
                    isLiked: post.isLikedBy(currentUserId),
                    count: post.likeCount,
                    onTap: onLike,
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
                  const Spacer(),
                  Text(
                    '${context.l10n.discussionPostedOn} $dateText',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
