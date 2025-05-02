import 'package:flutter/material.dart';
import '../widgets/form_input.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _onLoginPressed() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // TODO: dispatch Bloc login event or call AuthRepo
    print('Login pressed: $email / $password');
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
        FormInput(label: 'Password', controller: _passwordController, obscureText: true),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _onLoginPressed,
          child: const Text('Login'),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () {
            // TODO: Navigate to Signup screen
          },
          child: const Text('Don’t have an account? Sign Up'),
        ),
      ],
    );
  }
}
