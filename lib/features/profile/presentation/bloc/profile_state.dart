import 'package:equatable/equatable.dart';

import '../../domain/failures/profile_failure.dart';

enum ProfileStatus { idle, uploading, success, error }

class ProfileState extends Equatable {
  final ProfileStatus status;
  final ProfileErrorCode? errorCode;

  const ProfileState({
    this.status = ProfileStatus.idle,
    this.errorCode,
  });

  const ProfileState.idle() : this();

  ProfileState copyWith({
    ProfileStatus? status,
    ProfileErrorCode? errorCode,
  }) =>
      ProfileState(
        status: status ?? this.status,
        errorCode: errorCode,
      );

  @override
  List<Object?> get props => [status, errorCode];
}
