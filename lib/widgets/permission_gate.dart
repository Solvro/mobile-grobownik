import "package:flutter/material.dart";

import "../services/location_permission_service.dart";

class PermissionGate extends StatefulWidget {
  const PermissionGate({required this.child, super.key});

  final Widget child;

  @override
  State<PermissionGate> createState() => _PermissionGateState();
}

class _PermissionGateState extends State<PermissionGate> with WidgetsBindingObserver {
  static const _service = LocationPermissionService();

  LocationPermissionStatus? _status;
  bool _checking = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _check();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _status != LocationPermissionStatus.granted) {
      _check();
    }
  }

  Future<void> _check() async {
    if (_checking) return;
    setState(() => _checking = true);
    final result = await _service.requestPermission();
    if (!mounted) return;
    setState(() {
      _status = result;
      _checking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_status == LocationPermissionStatus.granted) {
      return widget.child;
    }

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: _checking && _status == null
                ? const CircularProgressIndicator()
                : _PermissionMessage(status: _status, onRetry: _check, service: _service),
          ),
        ),
      ),
    );
  }
}

class _PermissionMessage extends StatelessWidget {
  const _PermissionMessage({required this.status, required this.onRetry, required this.service});

  final LocationPermissionStatus? status;
  final VoidCallback onRetry;
  final LocationPermissionService service;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    String title;
    String message;
    String buttonLabel;
    Future<void> Function() onPressed;

    switch (status) {
      case LocationPermissionStatus.serviceDisabled:
        title = "Lokalizacja jest wyłączona";
        message = "Włącz usługę lokalizacji (GPS) w ustawieniach systemu, aby korzystać z aplikacji.";
        buttonLabel = "Otwórz ustawienia lokalizacji";
        onPressed = () async {
          await service.openLocationSettings();
          onRetry();
        };
      case LocationPermissionStatus.denied:
      case null:
      case LocationPermissionStatus.granted:
        title = "Brak dostępu do lokalizacji";
        message = "Uprawnienia zostały odrzucone. Możesz je zmienić w ustawieniach aplikacji.";
        buttonLabel = "Otwórz ustawienia aplikacji";
        onPressed = () async {
          await service.openAppSettings();
          onRetry();
        };
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.location_on_outlined, size: 64),
        const SizedBox(height: 16),
        Text(title, style: theme.textTheme.headlineSmall, textAlign: TextAlign.center),
        const SizedBox(height: 12),
        Text(message, style: theme.textTheme.bodyMedium, textAlign: TextAlign.center),
        const SizedBox(height: 24),
        FilledButton(onPressed: onPressed, child: Text(buttonLabel)),
      ],
    );
  }
}