import 'package:cross_file/cross_file.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';

/// Boundary for profile-related mutations. The current photoUrl itself
/// is already exposed via [AppUser] from the auth feature, so this
/// repository deals only with the write/delete side of the contract.
abstract class ProfileRepository {
  /// Uploads [imageFile] to Storage at `users/{uid}/profile.jpg`,
  /// then writes the resulting download URL to both
  /// `FirebaseAuth.currentUser.photoURL` and the Firestore user doc.
  /// Returns the download URL on success.
  Future<Either<Failure, String>> uploadProfileImage({
    required String uid,
    required XFile imageFile,
  });

  /// Deletes the Storage file at `users/{uid}/profile.jpg` and clears the
  /// `photoUrl` fields in FirebaseAuth + Firestore.
  Future<Either<Failure, Unit>> removeProfileImage({
    required String uid,
  });
}
