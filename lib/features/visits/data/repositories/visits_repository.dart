import "package:dio/dio.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../../../common/models/location.dart";
import "../../../../common/network/directus_client.dart";
import "../../../grave/data/repositories/graves_repository.dart";
import "../models/visit_record.dart";

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
