import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:mobile_grobownik/core/network/dio_provider.dart';
import 'package:mobile_grobownik/models/grave.dart';
import 'package:mobile_grobownik/models/location.dart';

part 'grave_repository.g.dart';

class GraveRepository {
  final Dio _dio;

  const GraveRepository(this._dio);

  Future<Grave> getGraveDetails(String id) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/graves/$id');
      return Grave.fromJson(response.data!);
    } catch (_) {
      return _getMockGrave(id);
    }
  }

  Future<void> markGraveAsVisited(String id) async {
    await _dio.post<void>('/graves/$id/visit');
  }

  Grave _getMockGrave(String id) {
    return Grave(
      id: id,
      firstName: 'Jan',
      lastName: 'Kowalski',
      biography:
          'Profesor Politechniki Wrocławskiej, wybitny naukowiec w dziedzinie informatyki.',
      location: const Location(latitude: 51.107885, longitude: 17.061849),
      photoUrls: [
        'https://images.unsplash.com/photo-1604580864964-c4b269d7124d',
      ],
      achievements: [],
    );
  }
}

@riverpod
GraveRepository graveRepository(Ref ref) {
  final dioClient = ref.watch(dioProvider);
  return GraveRepository(dioClient);
}
