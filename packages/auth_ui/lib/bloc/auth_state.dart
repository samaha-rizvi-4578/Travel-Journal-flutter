import 'package:equatable/equatable.dart';
import 'package:auth_repo/auth_repo.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthState extends Equatable {
  final AuthStatus status;
  final User? user;

  const AuthState._({
    required this.status,
    this.user,
  });

  const AuthState.unknown() : this._(status: AuthStatus.unknown);

  const AuthState.authenticated(User user)
      : this._(status: AuthStatus.authenticated, user: user);

  const AuthState.unauthenticated()
      : this._(status: AuthStatus.unauthenticated);

  @override
  List<Object?> get props => [status, user ?? 'null'];
}
