import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
 static const String baseUrl = 'http://localhost:5000';


  static Future<http.Response> post(
    String path,
    Map<String, dynamic> body, {
    String? token,
  }) async {
    final url = Uri.parse('$baseUrl$path');

    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    return await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );
  }

  static Future<http.Response> get(
    String path, {
    String? token,
  }) async {
    final url = Uri.parse('$baseUrl$path');

    final headers = {
      if (token != null) 'Authorization': 'Bearer $token',
    };

    return await http.get(url, headers: headers);
  }
}
