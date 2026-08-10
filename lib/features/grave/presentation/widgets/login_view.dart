import "dart:async";

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "../services/auth_service.dart";
import "user_stats_view.dart";

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  var _isLoading = false;

  @override
  void initState() {
    super.initState();
    unawaited(_checkAutoLogin());
  }

  Future<void> _checkAutoLogin() async {
    final creds = await AuthService.getStoredCredentials();

    if (creds["email"] != null && creds["password"] != null) {
      _emailController.text = creds["email"]!;
      _passwordController.text = creds["password"]!;

      await _handleLogin(creds["email"]!, creds["password"]!);
    }
  }

  Future<void> _handleLogin(String email, String password) async {
    setState(() => _isLoading = true);

    final success = await AuthService.login(email, password);

    if (mounted) {
      setState(() => _isLoading = false);

      if (success) {
        await Navigator.pushReplacement(context, MaterialPageRoute<void>(builder: (context) => const UserStatsPage()));
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Login failed. Check your credentials.")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            const SizedBox(height: 32),
            if (_isLoading)
              const CircularProgressIndicator()
            else
              ElevatedButton(
                onPressed: () async {
                  await HapticFeedback.selectionClick();
                  await _handleLogin(_emailController.text.trim(), _passwordController.text.trim());
                },
                child: const Text("Login"),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
