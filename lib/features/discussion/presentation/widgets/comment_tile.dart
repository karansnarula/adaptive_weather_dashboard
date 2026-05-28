import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimens.dart';
import '../../domain/entities/comment.dart';

/// Single comment row: avatar (initial) + name + text. No date shown
/// (intentional, per UX spec). Long-press shows a delete confirmation
/// if [canDelete] is true.
class CommentTile extends StatelessWidget {
  final Comment comment;
  final bool canDelete;
  final VoidCallback? onDelete;

  const CommentTile({
    super.key,
    required this.comment,
    this.canDelete = false,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final initial = comment.authorName.isNotEmpty
        ? comment.authorName[0].toUpperCase()
        : '?';

    return InkWell(
      onLongPress: canDelete ? onDelete : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.spaceLg,
          vertical: AppDimens.spaceMd,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: AppDimens.circleAvatarRadius,
              backgroundColor: scheme.primaryContainer,
              child: Text(
                initial,
                style: TextStyle(
                  color: scheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: AppDimens.spaceMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    comment.authorName,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: AppDimens.spaceXxs),
                  Text(
                    comment.text,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
