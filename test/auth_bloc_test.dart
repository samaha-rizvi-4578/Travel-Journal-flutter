import 'package:auth_repo/auth_repo.dart';
import 'package:auth_ui/auth_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late AuthBloc authBloc;
  late MockAuthRepository mockAuthRepository;
  final testUser = User(id: '123', email: 'test@example.com');

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    authBloc = AuthBloc(authRepo: mockAuthRepository);
  });

  tearDown(() => authBloc.close());

  blocTest<AuthBloc, AuthState>(
    'emits [authenticated] when login succeeds',
    build: () => authBloc,
    setUp: () => when(mockAuthRepository.logIn(
      email: anyNamed('email'),
      password: anyNamed('password'),
    )).thenAnswer((_) async => testUser),
    act: (bloc) => bloc.add(AuthLoginRequested('test@example.com', 'pass')),
    expect: () => [AuthState.authenticated(testUser)],
  );

  blocTest<AuthBloc, AuthState>(
    'emits [failure] when login fails',
    build: () => authBloc,
    setUp: () => when(mockAuthRepository.logIn(
      email: anyNamed('email'),
      password: anyNamed('password'),
    )).thenThrow(Exception('Invalid credentials')),
    act: (bloc) => bloc.add(AuthLoginRequested('test@example.com', 'pass')),
    expect: () => [AuthState.failure('Exception: Invalid credentials')],
  );

  blocTest<AuthBloc, AuthState>(
    'emits [unauthenticated] when logout succeeds',
    build: () => authBloc,
    setUp: () => when(mockAuthRepository.logOut()).thenAnswer((_) async {}),
    act: (bloc) => bloc.add(AuthLogoutRequested()),
    expect: () => [const AuthState.unauthenticated()],
  );
}