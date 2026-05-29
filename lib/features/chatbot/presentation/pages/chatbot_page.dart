import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/responsive/responsive_builder.dart';
import '../../../../di/injection.dart';
import '../bloc/chatbot_bloc.dart';
import '../bloc/chatbot_event.dart';
import '../bloc/chatbot_state.dart';
import '../layouts/chatbot_desktop.dart';
import '../layouts/chatbot_mobile.dart';
import '../layouts/chatbot_tablet.dart';
import '../widgets/quota_indicator.dart';

class ChatbotPage extends StatelessWidget {
  /// Last searched city from the `?city=` route query param. Optional —
  /// the chatbot is fully functional without it.
  final String? city;

  const ChatbotPage({super.key, this.city});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ChatbotBloc>()..add(InitChat(city: city)),
      child: _ChatbotView(),
    );
  }
}

class _ChatbotView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatbotBloc, ChatbotState>(
      listenWhen: (prev, curr) =>
          curr.transientError != null &&
          prev.transientError != curr.transientError,
      listener: (context, state) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(state.transientError!)));
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.chatbotPageTitle),
          actions: const [QuotaIndicator()],
        ),
        body: SafeArea(
          child: ResponsiveBuilder(
            mobile: (_) => const ChatbotMobile(),
            tablet: (_) => const ChatbotTablet(),
            desktop: (_) => const ChatbotDesktop(),
          ),
        ),
      ),
    );
  }
}
