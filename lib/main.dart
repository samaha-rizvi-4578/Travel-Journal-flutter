import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:auth_repo/auth_repo.dart';
import 'firebase_options.dart';
import 'app.dart';

late final AuthRepository globalAuthRepo;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final authRepo = AuthRepository();
  runApp(App(authRepo: authRepo));
}