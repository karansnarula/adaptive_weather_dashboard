import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimens.dart';

/// Network-loaded image with proper loading + error states. The hosting
/// caller controls the size via [aspectRatio] — feed cards use 16:9, the
/// detail page uses 16:10.
class PostImage extends StatelessWidget {
  final String url;
  final double aspectRatio;

  const PostImage({
    super.key,
    required this.url,
    this.aspectRatio = 16 / 9,
  });

  @override
  Widget build(BuildContext context) {
    if (url.trim().isEmpty) return const SizedBox.shrink();
    final scheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppDimens.radiusLg),
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: Image.network(
          url,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;
            return Container(
              color: scheme.surfaceContainerHigh,
              child: const Center(child: CircularProgressIndicator()),
            );
          },
          errorBuilder: (context, _, __) => Container(
            color: scheme.surfaceContainerHigh,
            alignment: Alignment.center,
            child: Icon(
              Icons.broken_image_outlined,
              size: AppDimens.iconLogo,
              color: scheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}
