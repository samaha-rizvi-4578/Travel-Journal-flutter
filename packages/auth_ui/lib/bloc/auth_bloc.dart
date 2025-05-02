import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth_repo/auth_repo.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const AuthState.unknown()) {
    on<AuthSignUpRequested>(_onSignup);
    on<AuthLoginRequested>(_onLogin);
    on<AuthLogoutRequested>(_onLogout);
    on<AuthUserChanged>(_onUserChanged);

    _authRepository.user.listen((user) {
      add(AuthUserChanged(user));
    });
  }

  Future<void> _onSignup(
    AuthSignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await _authRepository.signUp(
        email: event.email,
        password: event.password,
      );
    } catch (_) {
      emit(const AuthState.unauthenticated());
    }
  }

  Future<void> _onLogin(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await _authRepository.logIn(
        email: event.email,
        password: event.password,
      );
    } catch (_) {
      emit(const AuthState.unauthenticated());
    }
  }

  Future<void> _onLogout(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _authRepository.logOut();
  }

  void _onUserChanged(
    AuthUserChanged event,
    Emitter<AuthState> emit,
  ) {
    final user = event.user;
    if (user != null) {
      emit(AuthState.authenticated(user));
    } else {
      emit(const AuthState.unauthenticated());
    }
  }
}
