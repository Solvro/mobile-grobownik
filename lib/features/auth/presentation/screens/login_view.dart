import "dart:async";

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../../../app/l10n/app_localizations.dart";
import "../../../user_stats/presentation/screens/user_stats_view.dart";
import "../../data/auth_service.dart";
import "../providers/auth_controller.dart";

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  var _isLoading = false;

  @override
  void initState() {
    super.initState();
    unawaited(_prefillStoredCredentials());
  }

  Future<void> _prefillStoredCredentials() async {
    final creds = await AuthService.getStoredCredentials();
    if (!mounted) return;

    _emailController.text = creds["email"] ?? "";
    _passwordController.text = creds["password"] ?? "";
  }

  Future<void> _handleLogin(String email, String password) async {
    setState(() => _isLoading = true);

    final result = await ref.read(authControllerProvider.notifier).login(email, password);

    if (mounted) {
      setState(() => _isLoading = false);

      if (result == LoginResult.success) {
        await Navigator.pushReplacement(context, MaterialPageRoute<void>(builder: (context) => const UserStatsPage()));
      } else {
        final l10n = AppLocalizations.of(context)!;
        final message = result == LoginResult.offline ? l10n.login_offline : l10n.login_failed;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.login)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: AppLocalizations.of(context)!.email),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: AppLocalizations.of(context)!.password),
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
                child: Text(AppLocalizations.of(context)!.login),
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
