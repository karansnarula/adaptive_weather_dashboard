import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/responsive/responsive_builder.dart';
import '../bloc/create_post/create_post_state.dart';
import '../bloc/feed/feed_bloc.dart';
import '../bloc/feed/feed_event.dart';
import '../bloc/unread/discussion_unread_bloc.dart';
import '../bloc/unread/discussion_unread_event.dart';
import '../layouts/feed_desktop.dart';
import '../layouts/feed_mobile.dart';
import '../layouts/feed_tablet.dart';
import '../widgets/create_post_sheet.dart';

/// Feed view for `/discussion`. The [FeedBloc] is provided one level up
/// in the route tree (a [ShellRoute] in `app_router.dart`) so the
/// [DiscussionDetailPage] can read and patch the same instance directly.
///
/// Stateful so it can fire `MarkAsVisited` on both [initState] (when the
/// user lands on the feed) and [dispose] (when the user pops back to the
/// weather page). The double-fire is intentional: the second one
/// captures any posts that arrived while the user was browsing so they
/// aren't double-counted on the next badge refresh.
class DiscussionFeedPage extends StatefulWidget {
  /// Last-searched city from the route's `?city=` query param. May be
  /// null — feed viewing works regardless. The FAB is disabled when
  /// null (you must search a city before posting, per UX spec).
  final String? city;

  const DiscussionFeedPage({super.key, this.city});

  @override
  State<DiscussionFeedPage> createState() => _DiscussionFeedPageState();
}

class _DiscussionFeedPageState extends State<DiscussionFeedPage> {
  /// Captured in [initState] so [dispose] can dispatch safely without
  /// touching [context] after the framework has dismantled inherited
  /// widgets.
  late final DiscussionUnreadBloc _unreadBloc;

  @override
  void initState() {
    super.initState();
    _unreadBloc = context.read<DiscussionUnreadBloc>();
    _unreadBloc.add(const MarkAsVisited());
  }

  @override
  void dispose() {
    // Pop out of the feed (back to /weather, or anywhere else): mark
    // the visit so any posts created while the user was browsing aren't
    // counted as "new" on the next badge refresh.
    _unreadBloc.add(const MarkAsVisited());
    super.dispose();
  }

  void _openCreateSheet(BuildContext context) {
    final c = widget.city;
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
    final city = widget.city;
    final hasCity = city != null && city.trim().isNotEmpty;
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
