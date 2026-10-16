import "dart:async";

import "package:connectivity_plus/connectivity_plus.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../../../common/sync/connectivity_provider.dart";
import "../../data/auth_service.dart";

part "auth_controller.g.dart";

enum AuthStatus { loggedOut, inProgress, loggedIn, failed, offline }

@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  var _running = false;

  @override
  AuthStatus build() {
    ref.listen(connectivityChangesProvider, (previous, next) {
      if (next case AsyncData(:final value)) _onConnectivityChanged(value);
    });

    unawaited(_loginWithStoredCredentials());

    return AuthStatus.inProgress;
  }

  void _onConnectivityChanged(List<ConnectivityResult> results) {
    if (results.contains(ConnectivityResult.none)) return;
    if (state == AuthStatus.offline) unawaited(_loginWithStoredCredentials());
  }

  Future<void> _loginWithStoredCredentials() async {
    if (_running) return;

    final credentials = await AuthService.getStoredCredentials();
    final email = credentials["email"];
    final password = credentials["password"];
    if (!ref.mounted) return;

    if (email == null || password == null) {
      state = AuthStatus.loggedOut;

      return;
    }

    await login(email, password);
  }

  Future<LoginResult> login(String email, String password) async {
    if (_running) return LoginResult.error;
    _running = true;
    state = AuthStatus.inProgress;

    try {
      final result = await AuthService.login(email, password);
      if (ref.mounted) {
        state = switch (result) {
          LoginResult.success => AuthStatus.loggedIn,
          LoginResult.offline => AuthStatus.offline,
          LoginResult.rejected || LoginResult.error => AuthStatus.failed,
        };
      }

      return result;
    } finally {
      _running = false;
    }
  }

  Future<void> logout() async {
    await AuthService.logout();
    if (ref.mounted) state = AuthStatus.loggedOut;
  }
}
