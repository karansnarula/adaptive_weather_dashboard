import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimens.dart';
import 'feed_mobile.dart';

class FeedTablet extends StatelessWidget {
  const FeedTablet({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: AppDimens.contentMaxWidthSm,
        ),
        child: const FeedMobile(),
      ),
    );
  }
}
