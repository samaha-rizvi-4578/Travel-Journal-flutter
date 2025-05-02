import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'models/user.dart';

class AuthRepository {
  final firebase.FirebaseAuth _firebaseAuth;

  AuthRepository({firebase.FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? firebase.FirebaseAuth.instance;

  Stream<User?> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      return firebaseUser == null ? null : User.fromFirebase(firebaseUser);
    });
  }

  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on firebase.FirebaseAuthException catch (e) {
      throw Exception('Failed to sign up: ${e.message}');
    }
  }

  Future<void> logIn({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on firebase.FirebaseAuthException catch (e) {
      throw Exception('Failed to log in: ${e.message}');
    }
  }

  Future<void> logOut() async {
    try {
      await _firebaseAuth.signOut();
    } on firebase.FirebaseAuthException catch (e) {
      throw Exception('Failed to log out: ${e.message}');
    }
  }

  User? get currentUser {
    final firebaseUser = _firebaseAuth.currentUser;
    return firebaseUser == null ? null : User.fromFirebase(firebaseUser);
  }
}