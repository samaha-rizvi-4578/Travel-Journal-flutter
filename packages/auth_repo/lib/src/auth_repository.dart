import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:shared_preferences/shared_preferences.dart';
import 'models/user.dart';

class AuthRepository {
  final firebase.FirebaseAuth _firebaseAuth;
  final StreamController<User?> _userController = StreamController.broadcast();
  User? _currentUser; // Cache for synchronous access

  AuthRepository({firebase.FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? firebase.FirebaseAuth.instance {
    _firebaseAuth.authStateChanges().listen((firebaseUser) async {
      if (firebaseUser != null) {
        final user = User.fromFirebase(firebaseUser);
        _currentUser = user; // cache it
        await _saveUserToLocal(user);
        _userController.add(user);
      } else {
        _currentUser = null;
        await _clearLocalUser();
        _userController.add(null);
      }
    });
  }

  /// Auth state stream
  Stream<User?> get user => _userController.stream;

  /// Getter for sync access
  User? get currentUser => _currentUser;

  /// Sign up
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
      if (firebaseUser == null) throw Exception('Sign up failed: no user');
      final user = User.fromFirebase(firebaseUser);
      _currentUser = user;
      await _saveUserToLocal(user);
      _userController.add(user);
      return user;
    } on firebase.FirebaseAuthException catch (e) {
      throw Exception('Failed to sign up: ${e.message}');
    }
  }

  /// Log in
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
      if (firebaseUser == null) throw Exception('Login failed: no user');
      final user = User.fromFirebase(firebaseUser);
      _currentUser = user;
      await _saveUserToLocal(user);
      _userController.add(user);
      return user;
    } on firebase.FirebaseAuthException catch (e) {
      throw Exception('Failed to log in: ${e.message}');
    }
  }

  /// Log out
  Future<void> logOut() async {
    try {
      await _firebaseAuth.signOut();
      _currentUser = null;
      await _clearLocalUser();
      _userController.add(null);
    } on firebase.FirebaseAuthException catch (e) {
      throw Exception('Failed to log out: ${e.message}');
    }
  }

  /// Save user locally
  Future<void> _saveUserToLocal(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', user.id);
    await prefs.setString('user_email', user.email ?? '');
  }

  /// Clear local user data
  Future<void> _clearLocalUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
    await prefs.remove('user_email');
  }

  void dispose() {
    _userController.close();
  }
}
