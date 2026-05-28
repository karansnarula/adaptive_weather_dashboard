import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimens.dart';
import 'detail_mobile.dart';

class DetailDesktop extends StatelessWidget {
  const DetailDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: AppDimens.contentMaxWidthSm,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.space3xl,
          ),
          child: const DetailMobile(),
        ),
      ),
    );
  }
}
