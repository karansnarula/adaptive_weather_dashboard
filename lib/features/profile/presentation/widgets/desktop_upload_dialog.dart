import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/app_dimens.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';

/// Centered dialog shown on desktop/web when the user taps their avatar
/// in Settings. The big drop zone in the middle is both a drag-and-drop
/// target (via desktop_drop) and a click-to-browse trigger (via
/// image_picker which opens a native file dialog).
class DesktopUploadDialog extends StatefulWidget {
  final bool hasCurrentPhoto;

  const DesktopUploadDialog({super.key, required this.hasCurrentPhoto});

  @override
  State<DesktopUploadDialog> createState() => _DesktopUploadDialogState();
}

class _DesktopUploadDialogState extends State<DesktopUploadDialog> {
  static final _picker = ImagePicker();
  static const _allowedExtensions = ['jpg', 'jpeg', 'png', 'webp', 'gif'];

  bool _isDragHover = false;
  String? _localErrorMessage;

  bool _isImageFile(XFile file) {
    final name = file.name.toLowerCase();
    return _allowedExtensions.any((ext) => name.endsWith('.$ext'));
  }

  void _dispatch(XFile file) {
    context.read<ProfileBloc>().add(UploadProfileImage(file));
    Navigator.of(context).pop();
  }

  Future<void> _pickViaClick() async {
    setState(() => _localErrorMessage = null);
    final file = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 70,
    );
    if (file == null) return;
    if (!mounted) return;
    _dispatch(file);
  }

  void _onDrop(DropDoneDetails details) {
    setState(() {
      _isDragHover = false;
      _localErrorMessage = null;
    });

    if (details.files.isEmpty) return;
    final file = details.files.first;

    if (!_isImageFile(file)) {
      setState(() => _localErrorMessage = 'Please drop an image file.');
      return;
    }

    _dispatch(file);
  }

  void _removePhoto() {
    context.read<ProfileBloc>().add(const RemoveProfileImage());
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final hasError = _localErrorMessage != null;
    final borderColor = hasError
        ? scheme.error
        : _isDragHover
            ? scheme.primary
            : scheme.outlineVariant;

    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460),
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.space2xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Upload profile image',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: AppDimens.spaceXl),
              DropTarget(
                onDragEntered: (_) =>
                    setState(() => _isDragHover = true),
                onDragExited: (_) =>
                    setState(() => _isDragHover = false),
                onDragDone: _onDrop,
                child: InkWell(
                  onTap: _pickViaClick,
                  borderRadius:
                      BorderRadius.circular(AppDimens.radiusLg),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      color: _isDragHover
                          ? scheme.primaryContainer.withValues(alpha: 0.3)
                          : scheme.surfaceContainerHigh,
                      borderRadius:
                          BorderRadius.circular(AppDimens.radiusLg),
                      border: Border.all(
                        color: borderColor,
                        width: 2,
                        style: _isDragHover
                            ? BorderStyle.solid
                            : BorderStyle.solid,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          hasError
                              ? Icons.error_outline
                              : _isDragHover
                                  ? Icons.file_download_outlined
                                  : Icons.cloud_upload_outlined,
                          size: AppDimens.iconLogo,
                          color: hasError
                              ? scheme.error
                              : _isDragHover
                                  ? scheme.primary
                                  : scheme.onSurfaceVariant,
                        ),
                        const SizedBox(height: AppDimens.spaceMd),
                        Text(
                          hasError
                              ? _localErrorMessage!
                              : _isDragHover
                                  ? 'Drop to upload'
                                  : 'Drag image here to upload',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: hasError
                                        ? scheme.error
                                        : scheme.onSurface,
                                  ),
                        ),
                        if (!hasError && !_isDragHover) ...[
                          const SizedBox(height: AppDimens.spaceXs),
                          Text(
                            'or click to browse',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: scheme.onSurfaceVariant,
                                ),
                          ),
                          const SizedBox(height: AppDimens.spaceXs),
                          Text(
                            'PNG, JPG, WebP · max 2MB',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: scheme.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              if (widget.hasCurrentPhoto) ...[
                const SizedBox(height: AppDimens.spaceLg),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _removePhoto,
                    icon: Icon(Icons.delete_outline, color: scheme.error),
                    label: Text(
                      'Delete current photo',
                      style: TextStyle(color: scheme.error),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: scheme.error),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: AppDimens.spaceLg),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
