import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthRemoteDataSource {
  final String baseUrl;

  AuthRemoteDataSource(this.baseUrl);

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/v1/auth/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Login failed');
    }
  }
  Future<Map<String, dynamic>> signup(String email, String password, String businessName) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/v1/auth/signup'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
        'businessName': businessName,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Signup failed');
    }
  }
}