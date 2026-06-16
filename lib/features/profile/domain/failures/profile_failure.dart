import '../../../../core/error/failures.dart';

enum ProfileErrorCode {
  notSignedIn,
  permissionDenied,
  notFound,
  canceled,
  quotaExceeded,
  invalidImage,
  unknown,
}

class ProfileFailure extends Failure {
  final ProfileErrorCode code;
  const ProfileFailure(this.code) : super('');

  @override
  List<Object> get props => [code];
}
