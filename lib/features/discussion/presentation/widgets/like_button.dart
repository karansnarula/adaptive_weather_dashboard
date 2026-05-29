import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimens.dart';

/// Heart icon with count. Filled red when the current user has liked.
class LikeButton extends StatelessWidget {
  final bool isLiked;
  final int count;
  final VoidCallback? onTap;

  const LikeButton({
    super.key,
    required this.isLiked,
    required this.count,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = isLiked ? scheme.error : scheme.onSurfaceVariant;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimens.radiusMd),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.spaceSm,
          vertical: AppDimens.spaceXs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isLiked ? Icons.favorite : Icons.favorite_border,
              size: AppDimens.iconSm,
              color: color,
            ),
            const SizedBox(width: AppDimens.spaceXs),
            Text(
              '$count',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: color,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
