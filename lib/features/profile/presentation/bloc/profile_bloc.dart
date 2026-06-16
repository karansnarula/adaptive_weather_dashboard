import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/failures/profile_failure.dart';
import '../../domain/usecases/remove_profile_image.dart' as uc_remove;
import '../../domain/usecases/upload_profile_image.dart' as uc_upload;
import 'profile_event.dart';
import 'profile_state.dart';

@injectable
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final uc_upload.UploadProfileImage _uploadProfileImage;
  final uc_remove.RemoveProfileImage _removeProfileImage;
  final FirebaseAuth _firebaseAuth;

  ProfileBloc(
    this._uploadProfileImage,
    this._removeProfileImage,
    this._firebaseAuth,
  ) : super(const ProfileState.idle()) {
    on<UploadProfileImage>(_onUpload);
    on<RemoveProfileImage>(_onRemove);
    on<ClearProfileError>(_onClearError);
  }

  Future<void> _onUpload(
    UploadProfileImage event,
    Emitter<ProfileState> emit,
  ) async {
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid == null) {
      emit(state.copyWith(
        status: ProfileStatus.error,
        errorCode: ProfileErrorCode.notSignedIn,
      ));
      return;
    }

    emit(state.copyWith(status: ProfileStatus.uploading));

    final result = await _uploadProfileImage(
      uid: uid,
      imageFile: event.imageFile,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: ProfileStatus.error,
        errorCode: failure is ProfileFailure
            ? failure.code
            : ProfileErrorCode.unknown,
      )),
      (_) => emit(state.copyWith(status: ProfileStatus.success)),
    );
  }

  Future<void> _onRemove(
    RemoveProfileImage event,
    Emitter<ProfileState> emit,
  ) async {
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid == null) {
      emit(state.copyWith(
        status: ProfileStatus.error,
        errorCode: ProfileErrorCode.notSignedIn,
      ));
      return;
    }

    emit(state.copyWith(status: ProfileStatus.uploading));

    final result = await _removeProfileImage(uid: uid);

    result.fold(
      (failure) => emit(state.copyWith(
        status: ProfileStatus.error,
        errorCode: failure is ProfileFailure
            ? failure.code
            : ProfileErrorCode.unknown,
      )),
      (_) => emit(state.copyWith(status: ProfileStatus.success)),
    );
  }

  void _onClearError(
    ClearProfileError event,
    Emitter<ProfileState> emit,
  ) {
    emit(state.copyWith(status: ProfileStatus.idle));
  }
}
