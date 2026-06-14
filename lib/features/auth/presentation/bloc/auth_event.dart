sealed class AuthEvent {
  const AuthEvent();
}

class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

class AuthSignUpRequested extends AuthEvent {
  final String email;
  final String password;
  final String? displayName;

  const AuthSignUpRequested({
    required this.email,
    required this.password,
    this.displayName,
  });
}

class AuthSignInRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthSignInRequested({
    required this.email,
    required this.password,
  });
}

class AuthSignOutRequested extends AuthEvent {
  const AuthSignOutRequested();
}

/// Forces FirebaseAuth.currentUser.reload() and re-emits the current
/// Authenticated state with the freshly-fetched user data. Used after
/// profile mutations (upload/remove image) so the avatar reflects
/// the change immediately on every platform.
class AuthRefreshRequested extends AuthEvent {
  const AuthRefreshRequested();
}