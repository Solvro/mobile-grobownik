import "package:dio/dio.dart";

import "../models/visit_record.dart";

extension DioFetchGraveVisitsX on Dio {
  Future<List<VisitRecord>> fetchMyGraveVisits(String graveId) async {
    final response = await get<Map<String, dynamic>>(
      "/items/Visits",
      queryParameters: {
        "filter[user_created][_eq]": r"$CURRENT_USER",
        "filter[grave][_eq]": graveId,
        "fields": "id,grave,submit_location,date_created",
        "sort": "-date_created",
        "limit": -1,
      },
    );
    final visits = response.data?["data"] as List? ?? [];

    return visits.map((dynamic item) => VisitRecord.fromJson(item as Map<String, dynamic>)).toList();
  }
}
