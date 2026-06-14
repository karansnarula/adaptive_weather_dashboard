import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/app_dimens.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';

/// Bottom modal sheet shown on mobile when the user taps their avatar
/// in Settings. Four actions: take a photo, pick from gallery, delete
/// the current photo (if one exists), and cancel.
class MobileUploadSheet extends StatelessWidget {
  final bool hasCurrentPhoto;

  const MobileUploadSheet({super.key, required this.hasCurrentPhoto});

  static final _picker = ImagePicker();

  Future<void> _pickFromSource(
    BuildContext context,
    ImageSource source,
  ) async {
    final file = await _picker.pickImage(
      source: source,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 70,
    );
    if (file == null) return;

    if (!context.mounted) return;
    context.read<ProfileBloc>().add(UploadProfileImage(file));
    Navigator.of(context).pop();
  }

  void _removePhoto(BuildContext context) {
    context.read<ProfileBloc>().add(const RemoveProfileImage());
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppDimens.spaceMd),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.spaceLg,
                vertical: AppDimens.spaceSm,
              ),
              child: Text(
                'Upload profile image',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Take photo'),
              onTap: () => _pickFromSource(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Select from gallery'),
              onTap: () => _pickFromSource(context, ImageSource.gallery),
            ),
            if (hasCurrentPhoto)
              ListTile(
                leading: Icon(
                  Icons.delete_outline,
                  color: scheme.error,
                ),
                title: Text(
                  'Delete current photo',
                  style: TextStyle(color: scheme.error),
                ),
                onTap: () => _removePhoto(context),
              ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.close),
              title: const Text('Cancel'),
              onTap: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}
