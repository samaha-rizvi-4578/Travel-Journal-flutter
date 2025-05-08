import 'package:auth_repo/auth_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'helpers/mock_firebase_auth.mocks.dart';

void main() {
  late AuthRepository authRepo;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockUserCredential mockUserCredential;
  late MockUser mockFirebaseUser;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockUserCredential = MockUserCredential();
    mockFirebaseUser = MockUser();
    authRepo = AuthRepository(firebaseAuth: mockFirebaseAuth);
    
    when(mockFirebaseUser.uid).thenReturn('123');
    when(mockFirebaseUser.email).thenReturn('test@example.com');
    when(mockUserCredential.user).thenReturn(mockFirebaseUser);
  });

  group('AuthRepository', () {
    test('signUp returns user when successful', () async {
      when(mockFirebaseAuth.createUserWithEmailAndPassword(
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenAnswer((_) async => mockUserCredential);

      final user = await authRepo.signUp(
        email: 'test@example.com',
        password: 'password123',
      );

      expect(user.email, 'test@example.com');
    });

    test('signUp throws exception on failure', () async {
      when(mockFirebaseAuth.createUserWithEmailAndPassword(
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenThrow(FirebaseAuthException(code: 'weak-password'));

      expect(() async => await authRepo.signUp(
        email: 'test@example.com',
        password: 'password123',
      ), throwsA(isA<Exception>()));
    });
  });
}