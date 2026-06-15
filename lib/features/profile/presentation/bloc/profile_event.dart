import 'package:cross_file/cross_file.dart';
import 'package:equatable/equatable.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class UploadProfileImage extends ProfileEvent {
  final XFile imageFile;
  const UploadProfileImage(this.imageFile);

  @override
  List<Object?> get props => [imageFile.path];
}

class RemoveProfileImage extends ProfileEvent {
  const RemoveProfileImage();
}

class ClearProfileError extends ProfileEvent {
  const ClearProfileError();
}
