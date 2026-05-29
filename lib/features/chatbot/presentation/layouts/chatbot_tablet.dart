import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimens.dart';
import '../widgets/chat_conversation.dart';
import '../widgets/chat_input_bar.dart';
import '../widgets/quota_banner.dart';

class ChatbotTablet extends StatelessWidget {
  const ChatbotTablet({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: AppDimens.contentMaxWidthSm,
        ),
        child: const Column(
          children: [
            Expanded(child: ChatConversation()),
            QuotaBanner(),
            ChatInputBar(),
          ],
        ),
      ),
    );
  }
}
