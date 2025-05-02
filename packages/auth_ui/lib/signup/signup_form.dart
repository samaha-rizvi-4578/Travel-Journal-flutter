import 'package:flutter/material.dart';
import '../widgets/form_input.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth_repo/auth_repo.dart'; // only needed if User is referenced
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _onSignupPressed() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    context.read<AuthBloc>().add(AuthSignUpRequested(email, password));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FormInput(label: 'Email', controller: _emailController),
        FormInput(
            label: 'Password',
            controller: _passwordController,
            obscureText: true),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _onSignupPressed,
          child: const Text('Sign Up'),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Return to login screen
          },
          child: const Text('Already have an account? Login'),
        ),
      ],
    );
  }
}
