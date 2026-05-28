import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/responsive/responsive_builder.dart';
import '../bloc/create_post/create_post_state.dart';
import '../bloc/feed/feed_bloc.dart';
import '../bloc/feed/feed_event.dart';
import '../layouts/feed_desktop.dart';
import '../layouts/feed_mobile.dart';
import '../layouts/feed_tablet.dart';
import '../widgets/create_post_sheet.dart';

/// Feed view for `/discussion`. The [FeedBloc] is provided one level up
/// in the route tree (a [ShellRoute] in `app_router.dart`) so the
/// [DiscussionDetailPage] can read and patch the same instance directly.
class DiscussionFeedPage extends StatelessWidget {
  /// Last-searched city from the route's `?city=` query param. May be
  /// null — feed viewing works regardless. The FAB is disabled when
  /// null (you must search a city before posting, per UX spec).
  final String? city;

  const DiscussionFeedPage({super.key, this.city});

  void _openCreateSheet(BuildContext context) {
    final c = city;
    if (c == null) return;
    showCreatePostSheet(
      context,
      city: c,
      onSubmitted: (CreatePostState state) {
        final created = state.createdPost;
        if (created != null) {
          context.read<FeedBloc>().add(PrependPost(created));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasCity = city != null && city!.trim().isNotEmpty;
    return Scaffold(
      appBar: AppBar(
        // The feed lives in a nested Navigator (ShellRoute), so AppBar's
        // auto-imply-leading can't detect that /weather sits underneath
        // /discussion in the URL stack. Wire the leading button explicitly
        // and pop via go_router so the URL stack is the source of truth.
        leading: BackButton(onPressed: () => context.pop()),
        title: Text(context.l10n.discussionFeedTitle),
      ),
      floatingActionButton: Tooltip(
        message: hasCity
            ? context.l10n.discussionAddPost
            : context.l10n.discussionSearchCityFirst,
        child: FloatingActionButton.extended(
          onPressed: hasCity ? () => _openCreateSheet(context) : null,
          icon: const Icon(Icons.add),
          label: Text(context.l10n.discussionAddPost),
        ),
      ),
      body: ResponsiveBuilder(
        mobile: (_) => const FeedMobile(),
        tablet: (_) => const FeedTablet(),
        desktop: (_) => const FeedDesktop(),
      ),
    );
  }
}
