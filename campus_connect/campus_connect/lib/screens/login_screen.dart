import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'home_screen.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}


class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isSignUp = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authVm = Provider.of<AuthViewModel>(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(controller: _emailController, decoration: InputDecoration(labelText: 'Email')),
            TextField(controller: _passwordController, obscureText: true, decoration: InputDecoration(labelText: 'Password')),
            SizedBox(height: 20),
            if (authVm.isLoading) CircularProgressIndicator()
            else ElevatedButton(
              onPressed: () async {
                final email = _emailController.text.trim();
                final password = _passwordController.text;
                  String? validationError;
                  if (email.isEmpty || password.isEmpty) {
                    validationError = 'Email and password cannot be empty.';
                  } else if (password.length < 6) {
                    validationError = 'Password must be at least 6 characters.';
                }
                if (validationError != null) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(validationError)));
                  return;
                }
                bool success = _isSignUp
                    ? await authVm.signUp(email, password)
                    : await authVm.signIn(email, password);
                if (!context.mounted) return;
                if (success) {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
                } else if (authVm.errorMessage != null) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(authVm.errorMessage!)));
                }
              },
              child: Text(_isSignUp ? 'Sign Up' : 'Sign In'),
            ),
            TextButton(
              onPressed: () => setState(() => _isSignUp = !_isSignUp),
              child: Text(_isSignUp ? 'Already have an account? Sign In' : 'New? Create Account'),
            ),
          ],
        ),
      ),
    );
  }
}
