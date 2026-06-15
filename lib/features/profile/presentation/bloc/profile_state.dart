import 'package:equatable/equatable.dart';

enum ProfileStatus { idle, uploading, success, error }

class ProfileState extends Equatable {
  final ProfileStatus status;
  final String? errorMessage;

  const ProfileState({
    this.status = ProfileStatus.idle,
    this.errorMessage,
  });

  const ProfileState.idle() : this();

  ProfileState copyWith({
    ProfileStatus? status,
    String? errorMessage,
  }) =>
      ProfileState(
        status: status ?? this.status,
        errorMessage: errorMessage,
      );

  @override
  List<Object?> get props => [status, errorMessage];
}
