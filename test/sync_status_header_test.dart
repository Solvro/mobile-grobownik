import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_test/flutter_test.dart";
import "package:intl/intl.dart";
import "package:mobile_grobownik/app/l10n/app_localizations.dart";
import "package:mobile_grobownik/common/sync/sync_controller.dart";
import "package:mobile_grobownik/common/sync/sync_status.dart";
import "package:mobile_grobownik/features/grave/presentation/widgets/sync_status_header.dart";

/// Reports a fixed status and counts how many times a sync was requested.
class _FakeSyncController extends SyncController {
  _FakeSyncController(this.initial);

  final SyncStatus initial;
  var syncCalls = 0;

  @override
  SyncStatus build() => initial;

  @override
  Future<void> sync() async {
    syncCalls++;
  }
}

String _time(DateTime value) => DateFormat("dd.MM.yyyy HH:mm").format(value.toLocal());

Future<_FakeSyncController> _pumpHeader(WidgetTester tester, SyncStatus status) async {
  final controller = _FakeSyncController(status);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [syncControllerProvider.overrideWith(() => controller)],
      child: const MaterialApp(
        locale: Locale("pl"),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: SyncStatusHeader()),
      ),
    ),
  );

  return controller;
}

IconButton _refreshButton(WidgetTester tester) => tester.widget<IconButton>(find.byType(IconButton));

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final syncedAt = DateTime.utc(2026, 10, 10, 21, 15);

  setUp(() {
    // HapticFeedback talks to the platform and nobody answers in a test.
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async => null,
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      null,
    );
  });

  testWidgets("shows progress and disables the button while syncing", (tester) async {
    await _pumpHeader(tester, const SyncInProgress());

    expect(find.text("Synchronizacja…"), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(_refreshButton(tester).onPressed, isNull);
  });

  testWidgets("shows when the data was synchronized", (tester) async {
    await _pumpHeader(tester, SyncSuccess(lastSyncedAt: syncedAt));

    expect(find.text("Zsynchronizowano: ${_time(syncedAt)}"), findsOneWidget);
    expect(_refreshButton(tester).onPressed, isNotNull);
  });

  testWidgets("shows the age of the data when offline", (tester) async {
    await _pumpHeader(tester, SyncFailure(error: Exception("offline"), isOffline: true, lastSyncedAt: syncedAt));

    expect(find.text("Brak połączenia. Dane z: ${_time(syncedAt)}"), findsOneWidget);
    expect(_refreshButton(tester).onPressed, isNotNull);
  });

  testWidgets("says there is no stored data when offline on first launch", (tester) async {
    await _pumpHeader(tester, SyncFailure(error: Exception("offline"), isOffline: true));

    expect(find.text("Brak połączenia. Brak zapisanych danych"), findsOneWidget);
  });

  testWidgets("shows a sync error that is not about the connection", (tester) async {
    await _pumpHeader(tester, SyncFailure(error: Exception("500"), isOffline: false, lastSyncedAt: syncedAt));

    expect(find.text("Błąd synchronizacji. Dane z: ${_time(syncedAt)}"), findsOneWidget);
  });

  testWidgets("shows nothing before the first sync when no data is stored", (tester) async {
    await _pumpHeader(tester, const SyncIdle());

    expect(find.textContaining("Dane z"), findsNothing);
    expect(_refreshButton(tester).onPressed, isNotNull);
  });

  testWidgets("tapping the button starts a sync", (tester) async {
    final controller = await _pumpHeader(tester, SyncSuccess(lastSyncedAt: syncedAt));

    await tester.tap(find.byTooltip("Odśwież dane"));
    await tester.pump();

    expect(controller.syncCalls, 1);
  });
}
