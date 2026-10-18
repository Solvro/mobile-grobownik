import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../../app/l10n/app_localizations.dart";
import "providers/auth_controller.dart";
import "screens/login_view.dart";

Future<bool> requireLogin(BuildContext context, WidgetRef ref) async {
  final l10n = AppLocalizations.of(context)!;

  void showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  switch (ref.read(authControllerProvider)) {
    case AuthStatus.loggedIn:
      return true;
    case AuthStatus.loggedOut || AuthStatus.failed:
      await Navigator.push(context, MaterialPageRoute<void>(builder: (context) => const LoginScreen()));
      return false;
    case AuthStatus.inProgress:
      showMessage(l10n.visit_login_in_progress);
      return false;
    case AuthStatus.offline:
      showMessage(l10n.login_offline);
      return false;
  }
}
