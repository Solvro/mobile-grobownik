import "package:dio/dio.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "../api_client/directus_client.dart";
import "../models/location.dart";
import "../models/visit_record.dart";
import "graves_repository.dart";

part "visits_repository.g.dart";

class VisitSubmissionException implements Exception {
  const VisitSubmissionException(this.cause);

  final DioException cause;

  @override
  String toString() => "VisitSubmissionException: ${cause.message ?? cause.type.name}";
}

@riverpod
class VisitsRepository extends _$VisitsRepository {
  @override
  void build() {}

  Future<VisitRecord> markGraveAsVisited({required String graveId, required Location currentSubmissionLocation}) async {
    final dioClient = ref.read(directusClientProvider);

    try {
      final response = await dioClient.post<Map<String, dynamic>>(
        "/Visits",
        data: {
          "grave": graveId,
          "submit_location": {
            "type": "Point",
            "coordinates": [currentSubmissionLocation.longitude, currentSubmissionLocation.latitude],
          },
        },
      );

      final responseData = response.data?["data"] as Map<String, dynamic>;
      final newLog = VisitRecord.fromJson(responseData);

      ref.invalidate(gravesRepositoryProvider);

      return newLog;
    } on DioException catch (e, stackTrace) {
      Error.throwWithStackTrace(VisitSubmissionException(e), stackTrace);
    }
  }
}
