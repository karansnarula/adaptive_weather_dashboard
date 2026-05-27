import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimens.dart';

/// Three-dot "AI is typing" animation, styled to match the assistant bubble.
class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: AppDimens.spaceXs),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.spaceLg,
          vertical: AppDimens.spaceMd,
        ),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHigh,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(AppDimens.radiusLg),
            topRight: Radius.circular(AppDimens.radiusLg),
            bottomLeft: Radius.circular(AppDimens.radiusXs),
            bottomRight: Radius.circular(AppDimens.radiusLg),
          ),
        ),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (i) {
                final t = (_controller.value + i * 0.2) % 1.0;
                final opacity = (1 - (t - 0.5).abs() * 2).clamp(0.25, 1.0);
                return Padding(
                  padding: EdgeInsets.only(
                    right: i == 2 ? 0 : AppDimens.spaceXxs,
                  ),
                  child: Opacity(
                    opacity: opacity,
                    child: Container(
                      width: AppDimens.spaceSm,
                      height: AppDimens.spaceSm,
                      decoration: BoxDecoration(
                        color: scheme.onSurfaceVariant,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                );
              }),
            );
          },
        ),
      ),
    );
  }
}
