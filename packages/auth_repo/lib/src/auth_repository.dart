import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'models/user.dart';

class AuthRepository {
  final firebase.FirebaseAuth _firebaseAuth;

  AuthRepository({firebase.FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? firebase.FirebaseAuth.instance;

  // Stream to listen for auth state changes (used for Bloc)
  Stream<User?> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      return firebaseUser == null ? null : User.fromFirebase(firebaseUser);
    });
  }

  // Sign up and return User
  Future<User> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final firebaseUser = credential.user;
      if (firebaseUser == null) {
        throw Exception('Sign up failed: no user returned');
      }
      return User.fromFirebase(firebaseUser);
    } on firebase.FirebaseAuthException catch (e) {
      throw Exception('Failed to sign up: ${e.message}');
    }
  }

  // Login and return User
  Future<User> logIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final firebaseUser = credential.user;
      if (firebaseUser == null) {
        throw Exception('Login failed: no user returned');
      }
      return User.fromFirebase(firebaseUser);
    } on firebase.FirebaseAuthException catch (e) {
      throw Exception('Failed to log in: ${e.message}');
    }
  }

  // Logout
  Future<void> logOut() async {
    try {
      await _firebaseAuth.signOut();
    } on firebase.FirebaseAuthException catch (e) {
      throw Exception('Failed to log out: ${e.message}');
    }
  }

  // Get current user synchronously
  User? get currentUser {
    final firebaseUser = _firebaseAuth.currentUser;
    return firebaseUser == null ? null : User.fromFirebase(firebaseUser);
  }
}
