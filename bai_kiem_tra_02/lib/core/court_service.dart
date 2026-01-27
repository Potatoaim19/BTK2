import 'dart:convert';
import '../models/court.dart';
import 'api_client.dart';
import 'storage.dart';

class CourtService {
  static Future<List<Court>> getCourts() async {
    final token = await Storage.getToken();

    final response = await ApiClient.get(
      '/api/courts',
      token: token,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((e) => Court.fromJson(e)).toList();
    }

    throw Exception('Failed to load courts');
  }
}
