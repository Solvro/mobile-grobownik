import "package:dio/dio.dart";
import "package:image_picker/image_picker.dart";

import "grave_correction.dart";

typedef CemeteryOption = ({String id, String name, String? address});

extension DioGraveCorrectionsX on Dio {
  Future<String> uploadCorrectionPhoto(XFile photo) async {
    final form = FormData.fromMap({
      "file": await MultipartFile.fromFile(
        photo.path,
        filename: photo.name,
        contentType: DioMediaType.parse(photo.mimeType ?? "image/jpeg"),
      ),
    });
    final response = await post<Map<String, dynamic>>(
      "/files",
      data: form,
      options: Options(contentType: "multipart/form-data"),
    );

    return (response.data!["data"] as Map<String, dynamic>)["id"] as String;
  }

  Future<void> submitGraveCorrection(GraveCorrectionDraft draft) async {
    await post<Map<String, dynamic>>("/items/GraveCorrections", data: draft.toJson());
  }

  Future<List<CemeteryOption>> fetchCemeteryOptions() async {
    final response = await get<Map<String, dynamic>>(
      "/items/Cemeteries",
      queryParameters: {"fields": "id,name,address", "sort": "name", "limit": -1},
    );
    final cemeteries = response.data?["data"] as List? ?? [];

    return [
      for (final item in cemeteries.cast<Map<String, dynamic>>())
        (id: item["id"] as String, name: item["name"] as String, address: item["address"] as String?),
    ];
  }
}
