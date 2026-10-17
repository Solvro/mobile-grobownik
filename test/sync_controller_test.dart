import "dart:async";
import "dart:convert";
import "dart:typed_data";
import "dart:ui" show AppLifecycleState;

import "package:connectivity_plus/connectivity_plus.dart";
import "package:dio/dio.dart";
import "package:drift/native.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mobile_grobownik/common/database/app_database.dart";
import "package:mobile_grobownik/common/database/app_database_provider.dart";
import "package:mobile_grobownik/common/models/location.dart";
import "package:mobile_grobownik/common/network/directus_client.dart";
import "package:mobile_grobownik/common/sync/app_lifecycle_provider.dart";
import "package:mobile_grobownik/common/sync/connectivity_provider.dart";
import "package:mobile_grobownik/common/sync/sync_controller.dart";
import "package:mobile_grobownik/common/sync/sync_status.dart";
import "package:mobile_grobownik/features/grave/data/models/grave.dart";
import "package:mobile_grobownik/features/grave/data/repositories/graves_repository.dart";

/// Plays the role of Directus: no real network, answers come from [onRequest].
class _FakeAdapter implements HttpClientAdapter {
  _FakeAdapter(this.onRequest);

  final ResponseBody Function(RequestOptions options) onRequest;
  var requestCount = 0;
  RequestOptions? lastRequest;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requestCount++;
    lastRequest = options;

    return onRequest(options);
  }

  @override
  void close({bool force = false}) {}
}

/// A grave as Directus returns it (relations wrapped in junction rows).
Map<String, dynamic> _directusGrave(String id, {String lastName = "Kowalski"}) => {
  "id": id,
  "firstName": "Jan",
  "lastName": lastName,
  "status": "published",
  "biography": null,
  "education": null,
  "birthDate": "1900-01-02",
  "deathDate": "1980-03-04",
  "location": {
    "type": "Point",
    "coordinates": [17.03, 51.11],
  },
  "subjects": [
    {
      "Subjects_id": {"id": "s1", "name": "Matematyka", "faculty": "WPPT"},
    },
  ],
  "achievements": <dynamic>[],
  "photos": [
    {"directus_files_id": "photo-$id"},
  ],
};

ResponseBody _jsonResponse(Object body, {int statusCode = 200}) {
  return ResponseBody.fromString(
    jsonEncode(body),
    statusCode,
    headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    },
  );
}

ResponseBody _gravesResponse(List<Map<String, dynamic>> graves) => _jsonResponse({"data": graves});

ResponseBody _noConnection(RequestOptions options) {
  throw DioException(requestOptions: options, type: DioExceptionType.connectionError);
}

/// Completes with the next [SyncSuccess] / [SyncFailure] the controller
/// reports. Call it BEFORE triggering the sync you want to wait for.
Future<SyncStatus> _nextFinished(ProviderContainer container) async {
  final completer = Completer<SyncStatus>();
  final subscription = container.listen<SyncStatus>(syncControllerProvider, (previous, next) {
    if (!completer.isCompleted && (next is SyncSuccess || next is SyncFailure)) {
      completer.complete(next);
    }
  });

  try {
    return await completer.future.timeout(const Duration(seconds: 5));
  } finally {
    subscription.close();
  }
}

/// Gives a (wrongly) started sync time to reach the fake adapter.
Future<void> _letEventsRun() => Future<void>.delayed(const Duration(milliseconds: 50));

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() => database.close());

  ProviderContainer createContainer(
    _FakeAdapter adapter, {
    Stream<List<ConnectivityResult>>? connectivity,
    Stream<AppLifecycleState>? lifecycle,
    Duration? resumeInterval,
  }) {
    final dio = Dio(BaseOptions(baseUrl: "https://directus.test"))..httpClientAdapter = adapter;

    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(database),
        directusClientProvider.overrideWithValue(dio),
        connectivityChangesProvider.overrideWith(
          (ref) => connectivity ?? const Stream<List<ConnectivityResult>>.empty(),
        ),
        appLifecycleChangesProvider.overrideWith((ref) => lifecycle ?? const Stream<AppLifecycleState>.empty()),
        if (resumeInterval != null) syncResumeIntervalProvider.overrideWithValue(resumeInterval),
      ],
    );
    addTearDown(container.dispose);

    return container;
  }

  test("downloads graves into the local database and reports success", () async {
    final adapter = _FakeAdapter((_) => _gravesResponse([_directusGrave("1"), _directusGrave("2", lastName: "Nowak")]));
    final container = createContainer(adapter);

    final status = await _nextFinished(container);

    expect(status, isA<SyncSuccess>());
    expect(adapter.requestCount, 1);
    expect(adapter.lastRequest?.queryParameters["limit"], -1, reason: "Directus returns only 100 items by default");

    final rows = await database.select(database.graves).get();
    expect(rows.map((row) => row.id), unorderedEquals(["1", "2"]));

    // The whole pipeline works: Directus JSON -> Grave -> database -> Grave.
    final grave = rows.firstWhere((row) => row.id == "1").toGrave();
    expect(grave, isNotNull);
    expect(grave!.subjects.single.name, "Matematyka");
    expect(grave.photoIds, ["photo-1"]);

    expect(await database.readLastSyncedAt(), (status as SyncSuccess).lastSyncedAt);
  });

  test("reports an offline failure with no data when there is no connection and nothing stored", () async {
    final container = createContainer(_FakeAdapter(_noConnection));

    final status = await _nextFinished(container);

    expect(status, isA<SyncFailure>());
    final failure = status as SyncFailure;
    expect(failure.isOffline, isTrue);
    expect(failure.lastSyncedAt, isNull, reason: "null means there is no data at all yet");
    expect(await database.select(database.graves).get(), isEmpty);
  });

  test("keeps the stored graves when a sync fails", () async {
    final knownSyncTime = DateTime.utc(2026, 1, 2, 3, 4, 5);
    await database.replaceAllGraves([
      const Grave(
        id: "old",
        firstName: "Anna",
        lastName: "Nowak",
        location: Location(type: "Point", coordinates: [17.0, 51.0]),
      ).toCompanion(),
    ], syncedAt: knownSyncTime);
    final container = createContainer(_FakeAdapter(_noConnection));

    final status = await _nextFinished(container);

    expect(status, isA<SyncFailure>());
    expect((status as SyncFailure).lastSyncedAt, knownSyncTime);

    final rows = await database.select(database.graves).get();
    expect(rows.map((row) => row.id), ["old"]);
    expect(await database.readLastSyncedAt(), knownSyncTime);
  });

  test("an HTTP error is a failure that is not offline", () async {
    final container = createContainer(_FakeAdapter((_) => _jsonResponse({"errors": <dynamic>[]}, statusCode: 500)));

    final status = await _nextFinished(container);

    expect(status, isA<SyncFailure>());
    expect((status as SyncFailure).isOffline, isFalse);
  });

  test("syncs again when the connection comes back", () async {
    final connectivity = StreamController<List<ConnectivityResult>>.broadcast();
    addTearDown(connectivity.close);

    var online = false;
    final adapter = _FakeAdapter((options) {
      if (!online) return _noConnection(options);

      return _gravesResponse([_directusGrave("1")]);
    });
    final container = createContainer(adapter, connectivity: connectivity.stream);

    expect(await _nextFinished(container), isA<SyncFailure>());

    online = true;
    final second = _nextFinished(container);
    connectivity.add([ConnectivityResult.wifi]);

    expect(await second, isA<SyncSuccess>());
    expect(await database.select(database.graves).get(), hasLength(1));
  });

  test("ignores sync() calls while a sync is running", () async {
    final adapter = _FakeAdapter((_) => _gravesResponse([_directusGrave("1")]));
    final container = createContainer(adapter);
    await _nextFinished(container);
    final requestsBefore = adapter.requestCount;

    final controller = container.read(syncControllerProvider.notifier);
    await Future.wait([controller.sync(), controller.sync()]);

    expect(adapter.requestCount, requestsBefore + 1);
  });

  group("returning to the app", () {
    late StreamController<AppLifecycleState> lifecycle;

    setUp(() => lifecycle = StreamController<AppLifecycleState>.broadcast());

    tearDown(() => lifecycle.close());

    test("does not sync again when the data is still fresh", () async {
      final adapter = _FakeAdapter((_) => _gravesResponse([_directusGrave("1")]));
      final container = createContainer(adapter, lifecycle: lifecycle.stream);
      await _nextFinished(container);
      final requestsBefore = adapter.requestCount;

      lifecycle.add(AppLifecycleState.resumed);
      await _letEventsRun();

      expect(adapter.requestCount, requestsBefore);
    });

    test("syncs again when the data is older than the interval", () async {
      final adapter = _FakeAdapter((_) => _gravesResponse([_directusGrave("1")]));
      final container = createContainer(adapter, lifecycle: lifecycle.stream, resumeInterval: Duration.zero);
      await _nextFinished(container);
      final requestsBefore = adapter.requestCount;

      final second = _nextFinished(container);
      lifecycle.add(AppLifecycleState.resumed);

      expect(await second, isA<SyncSuccess>());
      expect(adapter.requestCount, requestsBefore + 1);
    });

    test("syncs again when the previous sync failed", () async {
      var online = false;
      final adapter = _FakeAdapter((options) {
        if (!online) return _noConnection(options);

        return _gravesResponse([_directusGrave("1")]);
      });
      final container = createContainer(adapter, lifecycle: lifecycle.stream);
      expect(await _nextFinished(container), isA<SyncFailure>());

      online = true;
      final second = _nextFinished(container);
      lifecycle.add(AppLifecycleState.resumed);

      expect(await second, isA<SyncSuccess>());
    });

    test("ignores lifecycle changes other than resumed", () async {
      final adapter = _FakeAdapter((_) => _gravesResponse([_directusGrave("1")]));
      final container = createContainer(adapter, lifecycle: lifecycle.stream, resumeInterval: Duration.zero);
      await _nextFinished(container);
      final requestsBefore = adapter.requestCount;

      lifecycle
        ..add(AppLifecycleState.inactive)
        ..add(AppLifecycleState.paused);
      await _letEventsRun();

      expect(adapter.requestCount, requestsBefore);
    });
  });
}
