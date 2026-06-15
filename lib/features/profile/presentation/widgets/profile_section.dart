import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_dimens.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../auth/domain/entities/app_user.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_state.dart';
import 'desktop_upload_dialog.dart';
import 'mobile_upload_sheet.dart';
import 'profile_avatar.dart';

/// Settings-page header: large tappable avatar over display name + email.
/// Tapping the avatar opens the platform-appropriate upload UI — bottom
/// modal on mobile, centered dialog with drop-zone on desktop/web.
/// Shows a SnackBar on upload success/failure.
class ProfileSection extends StatelessWidget {
  const ProfileSection({super.key});

  static const _avatarSize = 96.0;

  bool get _isMobile =>
      !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  void _openUploadUI(BuildContext context, AppUser user) {
    final hasCurrentPhoto =
        user.photoUrl != null && user.photoUrl!.trim().isNotEmpty;
    final bloc = context.read<ProfileBloc>();

    if (_isMobile) {
      showModalBottomSheet(
        context: context,
        showDragHandle: true,
        builder: (_) => BlocProvider.value(
          value: bloc,
          child: MobileUploadSheet(hasCurrentPhoto: hasCurrentPhoto),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (_) => BlocProvider.value(
          value: bloc,
          child: DesktopUploadDialog(hasCurrentPhoto: hasCurrentPhoto),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: (context, state) {
        if (state.status == ProfileStatus.success) {
          // Tell AuthBloc to refresh its current-user state so the new
          // photoUrl propagates to every avatar instantly. `userChanges`
          // alone isn't reliable for updatePhotoURL events on web/iOS.
          context.read<AuthBloc>().add(const AuthRefreshRequested());
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(context.l10n.profileUpdated)),
            );
        } else if (state.status == ProfileStatus.error &&
            state.errorMessage != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(state.errorMessage!)),
            );
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          if (authState is! Authenticated) {
            return const SizedBox.shrink();
          }
          final user = authState.user;

          return BlocBuilder<ProfileBloc, ProfileState>(
            buildWhen: (prev, curr) => prev.status != curr.status,
            builder: (context, profileState) {
              final isUploading =
                  profileState.status == ProfileStatus.uploading;

              return Column(
                children: [
                  SizedBox(
                    width: _avatarSize,
                    height: _avatarSize,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        ProfileAvatar(
                          photoUrl: user.photoUrl,
                          size: _avatarSize,
                          onTap: isUploading
                              ? null
                              : () => _openUploadUI(context, user),
                        ),
                        if (isUploading)
                          const CircularProgressIndicator(strokeWidth: 3),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppDimens.spaceMd),
                  Text(
                    user.displayName?.isNotEmpty == true
                        ? user.displayName!
                        : user.email,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: AppDimens.spaceXs),
                  Text(
                    user.email,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurfaceVariant,
                        ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
