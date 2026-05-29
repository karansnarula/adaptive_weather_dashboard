import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/responsive/responsive_builder.dart';
import '../../../../di/injection.dart';
import '../bloc/detail/detail_bloc.dart';
import '../bloc/detail/detail_event.dart';
import '../bloc/detail/detail_state.dart';
import '../bloc/feed/feed_bloc.dart';
import '../bloc/feed/feed_event.dart';
import '../layouts/detail_desktop.dart';
import '../layouts/detail_mobile.dart';
import '../layouts/detail_tablet.dart';

class DiscussionDetailPage extends StatelessWidget {
  final String postId;

  const DiscussionDetailPage({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DetailBloc>(
      create: (_) => getIt<DetailBloc>()..add(LoadDetail(postId)),
      child: const _DetailView(),
    );
  }
}

class _DetailView extends StatelessWidget {
  const _DetailView();

  Future<void> _confirmDeletePost(BuildContext context) async {
    final l = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.discussionDeletePostTitle),
        content: Text(l.discussionDeletePostBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l.discussionCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l.discussionDelete),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      context.read<DetailBloc>().add(const DeleteCurrentPost());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // Surface transient errors as SnackBars.
        BlocListener<DetailBloc, DetailState>(
          listenWhen: (prev, curr) =>
              curr.transientError != null &&
              prev.transientError != curr.transientError,
          listener: (context, state) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.transientError!)));
          },
        ),
        // Post deleted → tell the shared FeedBloc to drop it from the
        // local list, then pop back to the feed. No refresh round-trip.
        BlocListener<DetailBloc, DetailState>(
          listenWhen: (prev, curr) =>
              prev.status != DetailStatus.deleted &&
              curr.status == DetailStatus.deleted,
          listener: (context, state) {
            final post = state.post;
            if (post != null) {
              context.read<FeedBloc>().add(RemovePostFromFeed(post.id));
            }
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/discussion');
            }
          },
        ),
        // Any mutation that changes the post in-place (like toggle,
        // comment added, comment removed) propagates back to the feed
        // so its in-memory list stays in sync without re-fetching.
        BlocListener<DetailBloc, DetailState>(
          listenWhen: (prev, curr) =>
              curr.post != null && prev.post != curr.post,
          listener: (context, state) {
            context.read<FeedBloc>().add(SyncPostInFeed(state.post!));
          },
        ),
      ],
      child: BlocBuilder<DetailBloc, DetailState>(
        buildWhen: (prev, curr) =>
            prev.post?.authorId != curr.post?.authorId ||
            prev.currentUserId != curr.currentUserId,
        builder: (context, state) {
          final post = state.post;
          final isAuthor = post != null &&
              state.currentUserId != null &&
              post.authorId == state.currentUserId;
          return Scaffold(
            appBar: AppBar(
              // Explicit BackButton — consistent with the feed page's
              // pattern. Inside the ShellRoute's nested Navigator this
              // pops back to /discussion via go_router.
              leading: BackButton(onPressed: () => context.pop()),
              title: Text(context.l10n.discussionPostTitle),
              actions: [
                if (isAuthor)
                  IconButton(
                    tooltip: context.l10n.discussionDeletePostTitle,
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => _confirmDeletePost(context),
                  ),
              ],
            ),
            body: SafeArea(
              child: ResponsiveBuilder(
                mobile: (_) => const DetailMobile(),
                tablet: (_) => const DetailTablet(),
                desktop: (_) => const DetailDesktop(),
              ),
            ),
          );
        },
      ),
    );
  }
}
