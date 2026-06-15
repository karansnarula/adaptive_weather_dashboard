import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_dimens.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../di/injection.dart';
import '../../data/news_service.dart';
import '../../domain/entities/news_article.dart';
import '../../domain/entities/news_category.dart';
import '../widgets/news_article_card.dart';

class NewsPage extends StatefulWidget {
  final String cityName;

  const NewsPage({super.key, required this.cityName});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  /// One future per visited tab. Caching avoids re-hitting NewsAPI's
  /// 100/day budget every time the user swipes between tabs.
  /// Pull-to-refresh replaces the entry for the active tab.
  final Map<NewsCategory, Future<List<NewsArticle>>> _futures = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: NewsCategory.values.length, vsync: this);
    _tabController.addListener(_onTabChanged);
    // Pre-load the initially-visible tab so the user doesn't see an
    // empty state before any fetch starts.
    _loadIfMissing(NewsCategory.weather);
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) return;
    _loadIfMissing(NewsCategory.values[_tabController.index]);
  }

  void _loadIfMissing(NewsCategory category) {
    if (_futures.containsKey(category)) return;
    setState(() {
      _futures[category] = getIt<NewsService>().getNews(
        widget.cityName,
        category,
      );
    });
  }

  Future<void> _refresh(NewsCategory category) async {
    setState(() {
      _futures[category] = getIt<NewsService>().getNews(
        widget.cityName,
        category,
      );
    });
    // Await so the RefreshIndicator hides only when the fetch finishes.
    await _futures[category];
  }

  Future<void> _openArticle(BuildContext context, NewsArticle article) async {
    final uri = Uri.tryParse(article.url);
    if (uri == null) {
      _showSnack(context, context.l10n.newsErrorOpening);
      return;
    }
    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.inAppBrowserView,
      );
      if (!launched && context.mounted) {
        _showSnack(context, context.l10n.newsErrorOpening);
      }
    } catch (_) {
      if (context.mounted) {
        _showSnack(context, context.l10n.newsErrorOpening);
      }
    }
  }

  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    // NewsAPI's free tier rejects requests from deployed browser
    // origins (HTTP 426). Even if a recruiter deep-links to /news/...
    // on web they shouldn't see the generic "couldn't load" error —
    // surface the actual reason instead.
    if (kIsWeb) {
      return Scaffold(
        appBar: AppBar(
          leading: BackButton(onPressed: () => context.pop()),
          title: Text(l10n.newsPageTitle(widget.cityName)),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppDimens.space2xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.web_asset_off,
                  size: AppDimens.iconLogo,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: AppDimens.spaceLg),
                Text(
                  l10n.newsNotAvailableOnWeb,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.pop()),
        title: Text(l10n.newsPageTitle(widget.cityName)),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: l10n.newsTabWeather),
            Tab(text: l10n.newsTabGeneral),
            Tab(text: l10n.newsTabTravel),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: NewsCategory.values.map((cat) {
          final future = _futures[cat];
          if (future == null) {
            // Tab hasn't been visited yet — the listener will populate
            // on first selection. Showing a spinner here is fine
            // because the listener fires synchronously enough that the
            // user rarely sees this state.
            return const Center(child: CircularProgressIndicator());
          }
          return _NewsList(
            future: future,
            onRefresh: () => _refresh(cat),
            onArticleTap: (article) => _openArticle(context, article),
          );
        }).toList(),
      ),
    );
  }
}

class _NewsList extends StatelessWidget {
  final Future<List<NewsArticle>> future;
  final Future<void> Function() onRefresh;
  final void Function(NewsArticle) onArticleTap;

  const _NewsList({
    required this.future,
    required this.onRefresh,
    required this.onArticleTap,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: FutureBuilder<List<NewsArticle>>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return _ErrorState(onRetry: onRefresh);
          }
          final articles = snapshot.data ?? const <NewsArticle>[];
          if (articles.isEmpty) return const _EmptyState();
          return _ArticleListView(
            articles: articles,
            onArticleTap: onArticleTap,
          );
        },
      ),
    );
  }
}

class _ArticleListView extends StatelessWidget {
  final List<NewsArticle> articles;
  final void Function(NewsArticle) onArticleTap;

  const _ArticleListView({
    required this.articles,
    required this.onArticleTap,
  });

  @override
  Widget build(BuildContext context) {
    // Constrain the list width on tablet/desktop so cards don't stretch
    // to ridiculous widths on big monitors. Single-column layout matches
    // the air_quality lightweight pattern.
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: AppDimens.contentMaxWidthSm,
        ),
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.spaceLg,
            vertical: AppDimens.spaceSm,
          ),
          itemCount: articles.length,
          itemBuilder: (context, i) {
            final article = articles[i];
            return NewsArticleCard(
              article: article,
              onTap: () => onArticleTap(article),
            );
          },
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListView(
      // ListView so RefreshIndicator can still detect the pull gesture.
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.space2xl,
            vertical: AppDimens.space5xl,
          ),
          child: Column(
            children: [
              Icon(
                Icons.newspaper_outlined,
                size: AppDimens.iconLogo,
                color: scheme.primary.withValues(alpha: 0.5),
              ),
              const SizedBox(height: AppDimens.spaceLg),
              Text(
                context.l10n.newsNoArticles,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ErrorState extends StatelessWidget {
  final Future<void> Function() onRetry;

  const _ErrorState({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(AppDimens.space2xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline,
                size: AppDimens.iconLogo,
                color: scheme.error,
              ),
              const SizedBox(height: AppDimens.spaceLg),
              Text(
                context.l10n.newsError,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppDimens.spaceLg),
              FilledButton(
                onPressed: () => onRetry(),
                child: Text(context.l10n.newsRetry),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
