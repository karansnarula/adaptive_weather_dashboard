import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimens.dart';
import 'detail_mobile.dart';

class DetailTablet extends StatelessWidget {
  const DetailTablet({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: AppDimens.contentMaxWidthSm,
        ),
        child: const DetailMobile(),
      ),
    );
  }
}
