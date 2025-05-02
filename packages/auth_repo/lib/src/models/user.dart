import 'package:firebase_auth/firebase_auth.dart' as firebase;

class User {
  final String id;
  final String email;

  User({
    required this.id,
    required this.email,
  });

  /// Factory constructor to convert Firebase User to our custom User model
  factory User.fromFirebase(firebase.User user) {
    return User(
      id: user.uid,
      email: user.email ?? '',
    );
  }
}
