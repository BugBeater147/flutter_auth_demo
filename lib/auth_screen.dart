import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isRegistering = false;

  void _toggleFormType() {
    setState(() {
      _isRegistering = !_isRegistering;
    });
  }

  void _submit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email and password')),
      );
      return;
    }

    firebase_auth.User? user;
    if (_isRegistering) {
      user = await _authService.registerWithEmailPassword(email, password);
    } else {
      user = await _authService.signInWithEmailPassword(email, password);
    }

    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ProfileScreen(user: user!), // Use `user!` to assert non-null
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Authentication failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isRegistering ? 'Register' : 'Sign In'),
        actions: [
          TextButton(
            onPressed: _toggleFormType,
            child: Text(_isRegistering ? 'Sign In' : 'Register'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _submit,
              child: Text(_isRegistering ? 'Register' : 'Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}
