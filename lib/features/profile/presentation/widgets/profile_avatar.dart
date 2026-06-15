import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Circular profile avatar with three visual states:
/// - has a usable [photoUrl] → loads via CachedNetworkImage with a soft
///   placeholder while fetching and an icon fallback on error;
/// - no photoUrl → renders [Icons.account_circle] tinted to fit;
/// - tap → invokes [onTap] (used by Settings to open the upload sheet).
class ProfileAvatar extends StatelessWidget {
  final String? photoUrl;
  final double size;
  final VoidCallback? onTap;

  const ProfileAvatar({
    super.key,
    required this.photoUrl,
    this.size = 40,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final hasUrl = photoUrl != null && photoUrl!.trim().isNotEmpty;

    final avatar = ClipOval(
      child: SizedBox(
        width: size,
        height: size,
        child: hasUrl
            ? CachedNetworkImage(
                imageUrl: photoUrl!,
                fit: BoxFit.cover,
                placeholder: (_, __) => _Placeholder(
                  size: size,
                  background: scheme.surfaceContainerHigh,
                ),
                errorWidget: (_, __, ___) => _FallbackIcon(
                  size: size,
                  background: scheme.surfaceContainerHigh,
                  iconColor: scheme.onSurfaceVariant,
                ),
              )
            : _FallbackIcon(
                size: size,
                background: scheme.surfaceContainerHigh,
                iconColor: scheme.onSurfaceVariant,
              ),
      ),
    );

    if (onTap == null) return avatar;
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: avatar,
    );
  }
}

class _Placeholder extends StatelessWidget {
  final double size;
  final Color background;
  const _Placeholder({required this.size, required this.background});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      color: background,
      alignment: Alignment.center,
      child: SizedBox(
        width: size * 0.35,
        height: size * 0.35,
        child: const CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }
}

class _FallbackIcon extends StatelessWidget {
  final double size;
  final Color background;
  final Color iconColor;
  const _FallbackIcon({
    required this.size,
    required this.background,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      color: background,
      child: Icon(
        Icons.account_circle,
        size: size,
        color: iconColor,
      ),
    );
  }
}
