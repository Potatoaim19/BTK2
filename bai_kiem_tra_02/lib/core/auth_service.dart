import 'dart:convert';
import 'api_client.dart';
import 'storage.dart';
import 'storage/token_storage.dart';


class AuthService {
  static Future<bool> login(String email, String password) async {
    final response = await ApiClient.post(
      '/api/auth/login',
      {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];
      await Storage.saveToken(token);
      return true;
    }

    return false;
  }
  static Future<void> logout() async {
    await TokenStorage.clear();
  }
}
