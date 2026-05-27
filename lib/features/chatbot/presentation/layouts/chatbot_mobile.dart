import 'package:flutter/material.dart';

import '../widgets/chat_conversation.dart';
import '../widgets/chat_input_bar.dart';
import '../widgets/quota_banner.dart';

class ChatbotMobile extends StatelessWidget {
  const ChatbotMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Expanded(child: ChatConversation()),
        QuotaBanner(),
        ChatInputBar(),
      ],
    );
  }
}
