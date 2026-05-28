import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_dimens.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../domain/entities/post.dart';
import '../bloc/feed/feed_bloc.dart';
import '../bloc/feed/feed_event.dart';
import '../bloc/feed/feed_state.dart';
import '../widgets/post_card.dart';

class FeedMobile extends StatelessWidget {
  const FeedMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedBloc, FeedState>(
      builder: (context, state) {
        return switch (state) {
          FeedInitial() || FeedLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
          FeedError(:final message) => _buildError(context, message),
          FeedLoaded(:final posts, :final currentUserId) =>
              _buildList(context, posts, currentUserId),
        };
      },
    );
  }

  Widget _buildList(
    BuildContext context,
    List<Post> posts,
    String? currentUserId,
  ) {
    if (posts.isEmpty) {
      return RefreshIndicator(
        onRefresh: () async {
          context.read<FeedBloc>().add(const RefreshFeed());
        },
        child: ListView(
          children: [_buildEmpty(context)],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<FeedBloc>().add(const RefreshFeed());
      },
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.spaceLg,
          vertical: AppDimens.spaceSm,
        ),
        itemCount: posts.length,
        itemBuilder: (context, i) {
          final p = posts[i];
          return PostCard(
            post: p,
            currentUserId: currentUserId,
            // No await-and-refresh needed: the detail page lives under
            // the same ShellRoute so it can patch this FeedBloc directly
            // (see UI-layer BlocListeners in DiscussionDetailPage).
            onTap: () => context.push('/discussion/${p.id}'),
            onLike: () =>
                context.read<FeedBloc>().add(ToggleLikeFromFeed(p.id)),
          );
        },
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.space2xl,
        vertical: AppDimens.space5xl,
      ),
      child: Column(
        children: [
          Icon(
            Icons.forum_outlined,
            size: AppDimens.iconLogo,
            color: scheme.primary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: AppDimens.spaceLg),
          Text(
            context.l10n.discussionNoPostsYet,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.space2xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: AppDimens.iconLogo,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: AppDimens.spaceLg),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: AppDimens.spaceLg),
            FilledButton(
              onPressed: () =>
                  context.read<FeedBloc>().add(const RefreshFeed()),
              child: Text(context.l10n.discussionRetry),
            ),
          ],
        ),
      ),
    );
  }
}
