import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_dimens.dart';
import '../../domain/entities/news_article.dart';

class NewsArticleCard extends StatelessWidget {
  final NewsArticle article;

  /// Fired when the user taps anywhere on the card. The parent decides
  /// how to open the URL (we use [launchUrl] with
  /// `LaunchMode.inAppBrowserView`).
  final VoidCallback onTap;

  const NewsArticleCard({
    super.key,
    required this.article,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final localeName = Localizations.localeOf(context).toLanguageTag();
    final dateText = DateFormat.yMMMd(localeName).format(
      article.publishedAt.toLocal(),
    );

    return Card(
      margin: const EdgeInsets.symmetric(vertical: AppDimens.spaceSm),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (article.imageUrl != null) _Image(url: article.imageUrl!),
            Padding(
              padding: const EdgeInsets.all(AppDimens.spaceLg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (article.sourceName.isNotEmpty)
                    Text(
                      article.sourceName,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: scheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  const SizedBox(height: AppDimens.spaceXs),
                  Text(
                    article.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  if (article.description.isNotEmpty) ...[
                    const SizedBox(height: AppDimens.spaceSm),
                    Text(
                      article.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                  const SizedBox(height: AppDimens.spaceMd),
                  Text(
                    dateText,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Image extends StatelessWidget {
  final String url;

  const _Image({required this.url});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Image.network(
        url,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Container(
            color: scheme.surfaceContainerHigh,
            child: const Center(child: CircularProgressIndicator()),
          );
        },
        errorBuilder: (context, _, __) => Container(
          color: scheme.surfaceContainerHigh,
          alignment: Alignment.center,
          child: Icon(
            Icons.broken_image_outlined,
            size: AppDimens.iconLogo,
            color: scheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
